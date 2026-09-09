package com.example.status_saver

import android.app.Activity
import android.content.ContentValues
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.DocumentsContract
import android.provider.MediaStore
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {

    private val CHANNEL =
        "com.example.status_saver/status"

    private val FOLDER_PICKER_REQUEST =
        1001

    // =============================================================
    // BACKGROUND EXECUTOR
    // =============================================================

    private val backgroundExecutor =
        Executors.newSingleThreadExecutor()

    private val mainHandler =
        Handler(Looper.getMainLooper())

    private var folderPickerResult:
            MethodChannel.Result? = null

    private var folderPickerSource:
            String? = null

    // =============================================================
    // FLUTTER METHOD CHANNEL
    // =============================================================

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(
            flutterEngine
        )

        MethodChannel(
            flutterEngine
                .dartExecutor
                .binaryMessenger,
            CHANNEL
        ).setMethodCallHandler {
                call,
                result ->

            when (call.method) {

                // =====================================================
                // GET APP STATE
                // =====================================================

                "getAppState" -> {

                    migrateLegacyFolder()

                    val whatsappInstalled =
                        isPackageInstalled(
                            "com.whatsapp"
                        )

                    val businessInstalled =
                        isPackageInstalled(
                            "com.whatsapp.w4b"
                        )

                    val whatsappConfigured =
                        hasStoredFolder(
                            "whatsapp"
                        )

                    val businessConfigured =
                        hasStoredFolder(
                            "business"
                        )

                    val preferences =
                        getSharedPreferences(
                            "status_saver",
                            MODE_PRIVATE
                        )

                    val lastSelectedSource =
                        preferences.getString(
                            "last_selected_source",
                            null
                        )

                    result.success(
                        mapOf(
                            "whatsappInstalled" to
                                    whatsappInstalled,

                            "businessInstalled" to
                                    businessInstalled,

                            "whatsappConfigured" to
                                    whatsappConfigured,

                            "businessConfigured" to
                                    businessConfigured,

                            "lastSelectedSource" to
                                    lastSelectedSource
                        )
                    )
                }

                // =====================================================
                // SELECT STATUS FOLDER
                // =====================================================

                "selectStatusFolder" -> {

                    val source =
                        call.argument<String>(
                            "source"
                        ) ?: "whatsapp"

                    if (
                        source != "whatsapp" &&
                        source != "business"
                    ) {
                        result.error(
                            "INVALID_SOURCE",
                            "Invalid WhatsApp source",
                            null
                        )

                        return@setMethodCallHandler
                    }

                    folderPickerResult =
                        result

                    folderPickerSource =
                        source

                    val intent =
                        Intent(
                            Intent.ACTION_OPEN_DOCUMENT_TREE
                        )

                    intent.addFlags(
                        Intent.FLAG_GRANT_READ_URI_PERMISSION or
                                Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                                Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION or
                                Intent.FLAG_GRANT_PREFIX_URI_PERMISSION
                    )

                    startActivityForResult(
                        intent,
                        FOLDER_PICKER_REQUEST
                    )
                }

                // =====================================================
                // GET DETECTED WHATSAPP STATUSES
                // =====================================================

                "getStatuses" -> {

                    val source =
                        call.argument<String>(
                            "source"
                        ) ?: "whatsapp"

                    val statuses =
                        getStatusesFromWhatsApp(
                            source
                        )

                    result.success(
                        statuses
                    )
                }

                // =====================================================
                // GET SAVED STATUSES
                // =====================================================

                "getSavedStatuses" -> {

                    backgroundExecutor.execute {

                        try {

                            val savedStatuses =
                                getSavedStatusesFromGallery()

                            mainHandler.post {

                                result.success(
                                    savedStatuses
                                )
                            }

                        } catch (e: Exception) {

                            Log.e(
                                "STATUS_DEBUG",
                                "Unable to load saved statuses",
                                e
                            )

                            mainHandler.post {

                                result.error(
                                    "SAVED_LOAD_ERROR",
                                    e.message,
                                    null
                                )
                            }
                        }
                    }
                }

                // =====================================================
                // REMEMBER LAST SOURCE
                // =====================================================

                "setLastSelectedSource" -> {

                    val source =
                        call.argument<String>(
                            "source"
                        )

                    if (
                        source != "whatsapp" &&
                        source != "business"
                    ) {

                        result.error(
                            "INVALID_SOURCE",
                            "Invalid WhatsApp source",
                            null
                        )

                        return@setMethodCallHandler
                    }

                    getSharedPreferences(
                        "status_saver",
                        MODE_PRIVATE
                    )
                        .edit()
                        .putString(
                            "last_selected_source",
                            source
                        )
                        .apply()

                    result.success(true)
                }

                // =====================================================
                // READ STATUS
                // =====================================================

                "readStatus" -> {

                    val uriString =
                        call.argument<String>(
                            "uri"
                        )

                    if (uriString == null) {

                        result.error(
                            "INVALID_URI",
                            "Status URI is missing",
                            null
                        )

                        return@setMethodCallHandler
                    }

                    try {

                        val uri =
                            Uri.parse(uriString)

                        val bytes =
                            contentResolver
                                .openInputStream(uri)
                                ?.use {
                                    it.readBytes()
                                }

                        if (bytes == null) {

                            result.error(
                                "READ_ERROR",
                                "Unable to read status file",
                                null
                            )

                        } else {

                            result.success(
                                bytes
                            )
                        }

                    } catch (e: Exception) {

                        result.error(
                            "READ_ERROR",
                            e.message,
                            null
                        )
                    }
                }

                // =====================================================
                // PREPARE STATUS
                //
                // IMPORTANT:
                // Copying happens away from Android UI thread.
                // =====================================================

                "prepareStatus" -> {

                    val uriString =
                        call.argument<String>(
                            "uri"
                        )

                    if (uriString == null) {

                        result.error(
                            "INVALID_URI",
                            "Status URI is missing",
                            null
                        )

                        return@setMethodCallHandler
                    }

                    val name =
                        call.argument<String>(
                            "name"
                        ) ?: "status"

                    backgroundExecutor.execute {

                        var outputFile:
                                File? = null

                        try {

                            val uri =
                                Uri.parse(
                                    uriString
                                )

                            val extension =
                                if (
                                    name.contains(
                                        "."
                                    )
                                ) {
                                    name
                                        .substringAfterLast(
                                            "."
                                        )
                                        .lowercase()
                                } else {
                                    "mp4"
                                }

                            outputFile =
                                File(
                                    cacheDir,
                                    "status_${System.currentTimeMillis()}.$extension"
                                )

                            val inputStream =
                                contentResolver
                                    .openInputStream(
                                        uri
                                    )

                            if (inputStream == null) {

                                mainHandler.post {

                                    result.error(
                                        "READ_ERROR",
                                        "Unable to open status file",
                                        null
                                    )
                                }

                                return@execute
                            }

                            inputStream.use { input ->

                                FileOutputStream(
                                    outputFile
                                ).use { output ->

                                    input.copyTo(
                                        output
                                    )
                                }
                            }

                            val preparedPath =
                                outputFile
                                    .absolutePath

                            mainHandler.post {

                                result.success(
                                    preparedPath
                                )
                            }

                        } catch (e: Exception) {

                            try {
                                outputFile?.delete()
                            } catch (_: Exception) {
                            }

                            mainHandler.post {

                                result.error(
                                    "PREPARE_ERROR",
                                    e.message,
                                    null
                                )
                            }
                        }
                    }
                }

                // =====================================================
                // SAVE STATUS TO GALLERY
                // =====================================================

                "saveStatus" -> {

                    val uriString =
                        call.argument<String>(
                            "uri"
                        )

                    val name =
                        call.argument<String>(
                            "name"
                        ) ?: "status"

                    val mimeType =
                        call.argument<String>(
                            "mimeType"
                        ) ?: ""

                    if (uriString == null) {

                        result.error(
                            "INVALID_URI",
                            "Status URI is missing",
                            null
                        )

                        return@setMethodCallHandler
                    }

                    backgroundExecutor.execute {

                        try {

                            val uri =
                                Uri.parse(
                                    uriString
                                )

                            val actualMimeType =
                                if (
                                    mimeType.isNotEmpty()
                                ) {
                                    mimeType
                                } else {
                                    contentResolver
                                        .getType(uri)
                                        ?: guessMimeType(
                                            name
                                        )
                                }

                            val saveResult =
                                saveStatusToGallery(
                                    uri,
                                    name,
                                    actualMimeType
                                )

                            mainHandler.post {

                                result.success(
                                    saveResult
                                )
                            }

                        } catch (e: Exception) {

                            Log.e(
                                "STATUS_DEBUG",
                                "Save error",
                                e
                            )

                            mainHandler.post {

                                result.error(
                                    "SAVE_ERROR",
                                    e.message,
                                    null
                                )
                            }
                        }
                    }
                }

                // =====================================================
                // SHARE STATUS
                // =====================================================

                "shareStatus" -> {

                    val uriString =
                        call.argument<String>(
                            "uri"
                        )

                    val filePath =
                        call.argument<String>(
                            "filePath"
                        )

                    val mimeType =
                        call.argument<String>(
                            "mimeType"
                        ) ?: "*/*"

                    if (
                        uriString == null &&
                        filePath == null
                    ) {

                        result.error(
                            "INVALID_SHARE_URI",
                            "Nothing available to share",
                            null
                        )

                        return@setMethodCallHandler
                    }

                    try {

                        val shareUri =
                            if (
                                !uriString.isNullOrEmpty()
                            ) {

                                Uri.parse(
                                    uriString
                                )

                            } else {

                                Uri.parse(
                                    filePath
                                )
                            }

                        val shareIntent =
                            Intent(
                                Intent.ACTION_SEND
                            ).apply {

                                type =
                                    if (
                                        mimeType.isNotEmpty()
                                    ) {
                                        mimeType
                                    } else {
                                        "*/*"
                                    }

                                putExtra(
                                    Intent.EXTRA_STREAM,
                                    shareUri
                                )

                                addFlags(
                                    Intent.FLAG_GRANT_READ_URI_PERMISSION
                                )
                            }

                        val chooser =
                            Intent.createChooser(
                                shareIntent,
                                "Share status"
                            )

                        startActivity(
                            chooser
                        )

                        result.success(true)

                    } catch (e: Exception) {

                        Log.e(
                            "STATUS_DEBUG",
                            "Share error",
                            e
                        )

                        result.error(
                            "SHARE_ERROR",
                            e.message,
                            null
                        )
                    }
                }

                // =====================================================
                // GET THUMBNAIL
                // =====================================================

                "getThumbnail" -> {

                    val uriString =
                        call.argument<String>(
                            "uri"
                        )

                    if (uriString == null) {

                        result.error(
                            "INVALID_URI",
                            "Status URI is missing",
                            null
                        )

                        return@setMethodCallHandler
                    }

                    try {

                        val uri =
                            Uri.parse(
                                uriString
                            )

                        val mimeType =
                            contentResolver
                                .getType(uri)
                                ?: ""

                        // -------------------------------------------------
                        // IMAGE
                        // -------------------------------------------------

                        if (
                            mimeType.startsWith(
                                "image/"
                            )
                        ) {

                            val bytes =
                                contentResolver
                                    .openInputStream(
                                        uri
                                    )
                                    ?.use {
                                        it.readBytes()
                                    }

                            if (bytes == null) {

                                result.error(
                                    "THUMBNAIL_ERROR",
                                    "Unable to read image",
                                    null
                                )

                            } else {

                                result.success(
                                    bytes
                                )
                            }
                        }

                        // -------------------------------------------------
                        // VIDEO
                        // -------------------------------------------------

                        else if (
                            mimeType.startsWith(
                                "video/"
                            )
                        ) {

                            val retriever =
                                MediaMetadataRetriever()

                            try {

                                retriever.setDataSource(
                                    this,
                                    uri
                                )

                                val bitmap =
                                    retriever.getFrameAtTime(
                                        0,
                                        MediaMetadataRetriever
                                            .OPTION_CLOSEST_SYNC
                                    )

                                if (bitmap == null) {

                                    result.error(
                                        "THUMBNAIL_ERROR",
                                        "Unable to generate video thumbnail",
                                        null
                                    )

                                } else {

                                    val stream =
                                        java.io.ByteArrayOutputStream()

                                    bitmap.compress(
                                        Bitmap.CompressFormat.JPEG,
                                        85,
                                        stream
                                    )

                                    result.success(
                                        stream.toByteArray()
                                    )

                                    bitmap.recycle()
                                }

                            } finally {

                                retriever.release()
                            }
                        }

                        // -------------------------------------------------
                        // UNKNOWN
                        // -------------------------------------------------

                        else {

                            result.error(
                                "UNSUPPORTED_TYPE",
                                "Unsupported media type: $mimeType",
                                null
                            )
                        }

                    } catch (e: Exception) {

                        Log.e(
                            "STATUS_DEBUG",
                            "Thumbnail error",
                            e
                        )

                        result.error(
                            "THUMBNAIL_ERROR",
                            e.message,
                            null
                        )
                    }
                }

                // =====================================================
                // UNKNOWN METHOD
                // =====================================================

                else -> {

                    result.notImplemented()
                }
            }
        }
    }

    // =============================================================
    // GET WHATSAPP STATUSES
    // =============================================================

    private fun getStatusesFromWhatsApp(
        source: String
    ): List<Map<String, String>> {

        val preferences =
            getSharedPreferences(
                "status_saver",
                MODE_PRIVATE
            )

        val preferenceKey =
            if (source == "business") {
                "whatsapp_business_status_folder_uri"
            } else {
                "whatsapp_status_folder_uri"
            }

        val uriString =
            preferences.getString(
                preferenceKey,
                null
            )

        if (uriString == null) {
            return emptyList()
        }

        val treeUri =
            Uri.parse(uriString)

        val statuses =
            mutableListOf<
                    Map<String, String>
                    >()

        val childrenUri =
            DocumentsContract
                .buildChildDocumentsUriUsingTree(
                    treeUri,
                    DocumentsContract
                        .getTreeDocumentId(
                            treeUri
                        )
                )

        val projection =
            arrayOf(
                DocumentsContract
                    .Document
                    .COLUMN_DOCUMENT_ID,

                DocumentsContract
                    .Document
                    .COLUMN_DISPLAY_NAME,

                DocumentsContract
                    .Document
                    .COLUMN_MIME_TYPE,

                DocumentsContract
                    .Document
                    .COLUMN_LAST_MODIFIED
            )

        contentResolver.query(
            childrenUri,
            projection,
            null,
            null,
            "${DocumentsContract.Document.COLUMN_LAST_MODIFIED} DESC"
        )?.use { cursor ->

            val idColumn =
                cursor.getColumnIndex(
                    DocumentsContract
                        .Document
                        .COLUMN_DOCUMENT_ID
                )

            val nameColumn =
                cursor.getColumnIndex(
                    DocumentsContract
                        .Document
                        .COLUMN_DISPLAY_NAME
                )

            val mimeColumn =
                cursor.getColumnIndex(
                    DocumentsContract
                        .Document
                        .COLUMN_MIME_TYPE
                )

            val modifiedColumn =
                cursor.getColumnIndex(
                    DocumentsContract
                        .Document
                        .COLUMN_LAST_MODIFIED
                )

            while (cursor.moveToNext()) {

                val documentId =
                    cursor.getString(
                        idColumn
                    )

                val name =
                    cursor.getString(
                        nameColumn
                    )

                val mimeType =
                    cursor.getString(
                        mimeColumn
                    )

                val lastModified =
                    if (
                        modifiedColumn >= 0 &&
                        !cursor.isNull(
                            modifiedColumn
                        )
                    ) {
                        cursor.getLong(
                            modifiedColumn
                        ).toString()
                    } else {
                        "0"
                    }

                if (
                    mimeType.startsWith(
                        "image/"
                    ) ||
                    mimeType.startsWith(
                        "video/"
                    )
                ) {

                    val documentUri =
                        DocumentsContract
                            .buildDocumentUriUsingTree(
                                treeUri,
                                documentId
                            )

                    statuses.add(
                        mapOf(
                            "name" to name,
                            "uri" to
                                    documentUri.toString(),
                            "mimeType" to
                                    mimeType,
                            "lastModified" to
                                    lastModified
                        )
                    )
                }
            }
        }

        return statuses
    }

    // =============================================================
    // GET SAVED MEDIA
    // =============================================================

    private fun getSavedStatusesFromGallery():
            List<Map<String, String>> {

        val statuses =
            mutableListOf<
                    Map<String, String>
                    >()

        if (
            Build.VERSION.SDK_INT >=
            Build.VERSION_CODES.Q
        ) {

            // -----------------------------------------------------
            // SAVED IMAGES
            // -----------------------------------------------------

            querySavedMedia(
                MediaStore.Images.Media
                    .getContentUri(
                        MediaStore
                            .VOLUME_EXTERNAL_PRIMARY
                    ),
                "Pictures/Status Saver",
                statuses
            )

            // -----------------------------------------------------
            // SAVED VIDEOS
            // -----------------------------------------------------

            querySavedMedia(
                MediaStore.Video.Media
                    .getContentUri(
                        MediaStore
                            .VOLUME_EXTERNAL_PRIMARY
                    ),
                "Movies/Status Saver",
                statuses
            )

        } else {

            // -----------------------------------------------------
            // ANDROID 9 AND BELOW
            // -----------------------------------------------------

            querySavedMediaLegacy(
                MediaStore.Images.Media
                    .EXTERNAL_CONTENT_URI,
                statuses
            )

            querySavedMediaLegacy(
                MediaStore.Video.Media
                    .EXTERNAL_CONTENT_URI,
                statuses
            )
        }

        statuses.sortByDescending {
            it["lastModified"]
                ?.toLongOrNull()
                ?: 0L
        }

        return statuses
    }

    // =============================================================
    // QUERY SAVED MEDIA ANDROID 10+
    // =============================================================

    private fun querySavedMedia(
        collection: Uri,
        relativePath: String,
        results:
        MutableList<
                Map<String, String>
                >
    ) {

        val projection =
            arrayOf(
                MediaStore.MediaColumns._ID,
                MediaStore.MediaColumns.DISPLAY_NAME,
                MediaStore.MediaColumns.MIME_TYPE,
                MediaStore.MediaColumns.DATE_MODIFIED,
                MediaStore.MediaColumns.RELATIVE_PATH
            )

        val selection =
            "${MediaStore.MediaColumns.RELATIVE_PATH} = ?"

        val selectionArgs =
            arrayOf(
                "$relativePath/"
            )

        contentResolver.query(
            collection,
            projection,
            selection,
            selectionArgs,
            "${MediaStore.MediaColumns.DATE_MODIFIED} DESC"
        )?.use { cursor ->

            val idColumn =
                cursor.getColumnIndex(
                    MediaStore.MediaColumns._ID
                )

            val nameColumn =
                cursor.getColumnIndex(
                    MediaStore.MediaColumns.DISPLAY_NAME
                )

            val mimeColumn =
                cursor.getColumnIndex(
                    MediaStore.MediaColumns.MIME_TYPE
                )

            val modifiedColumn =
                cursor.getColumnIndex(
                    MediaStore.MediaColumns.DATE_MODIFIED
                )

            while (cursor.moveToNext()) {

                if (idColumn < 0 ||
                    nameColumn < 0
                ) {
                    continue
                }

                val id =
                    cursor.getLong(
                        idColumn
                    )

                val name =
                    cursor.getString(
                        nameColumn
                    )

                val mimeType =
                    if (
                        mimeColumn >= 0 &&
                        !cursor.isNull(
                            mimeColumn
                        )
                    ) {
                        cursor.getString(
                            mimeColumn
                        )
                    } else {
                        guessMimeType(
                            name
                        )
                    }

                val modified =
                    if (
                        modifiedColumn >= 0 &&
                        !cursor.isNull(
                            modifiedColumn
                        )
                    ) {
                        cursor.getLong(
                            modifiedColumn
                        )
                    } else {
                        0L
                    }

                val uri =
                    Uri.withAppendedPath(
                        collection,
                        id.toString()
                    )

                results.add(
                    mapOf(
                        "name" to name,
                        "uri" to
                                uri.toString(),
                        "mimeType" to
                                mimeType,
                        "lastModified" to
                                modified.toString()
                    )
                )
            }
        }
    }

    // =============================================================
    // QUERY SAVED MEDIA LEGACY
    // =============================================================

    private fun querySavedMediaLegacy(
        collection: Uri,
        results:
        MutableList<
                Map<String, String>
                >
    ) {

        val projection =
            arrayOf(
                MediaStore.MediaColumns._ID,
                MediaStore.MediaColumns.DISPLAY_NAME,
                MediaStore.MediaColumns.MIME_TYPE,
                MediaStore.MediaColumns.DATE_MODIFIED
            )

        contentResolver.query(
            collection,
            projection,
            null,
            null,
            "${MediaStore.MediaColumns.DATE_MODIFIED} DESC"
        )?.use { cursor ->

            val idColumn =
                cursor.getColumnIndex(
                    MediaStore.MediaColumns._ID
                )

            val nameColumn =
                cursor.getColumnIndex(
                    MediaStore.MediaColumns.DISPLAY_NAME
                )

            val mimeColumn =
                cursor.getColumnIndex(
                    MediaStore.MediaColumns.MIME_TYPE
                )

            val modifiedColumn =
                cursor.getColumnIndex(
                    MediaStore.MediaColumns.DATE_MODIFIED
                )

            while (cursor.moveToNext()) {

                if (
                    idColumn < 0 ||
                    nameColumn < 0
                ) {
                    continue
                }

                val id =
                    cursor.getLong(
                        idColumn
                    )

                val name =
                    cursor.getString(
                        nameColumn
                    )

                val mimeType =
                    if (
                        mimeColumn >= 0 &&
                        !cursor.isNull(
                            mimeColumn
                        )
                    ) {
                        cursor.getString(
                            mimeColumn
                        )
                    } else {
                        guessMimeType(
                            name
                        )
                    }

                val modified =
                    if (
                        modifiedColumn >= 0 &&
                        !cursor.isNull(
                            modifiedColumn
                        )
                    ) {
                        cursor.getLong(
                            modifiedColumn
                        )
                    } else {
                        0L
                    }

                val uri =
                    Uri.withAppendedPath(
                        collection,
                        id.toString()
                    )

                results.add(
                    mapOf(
                        "name" to name,
                        "uri" to
                                uri.toString(),
                        "mimeType" to
                                mimeType,
                        "lastModified" to
                                modified.toString()
                    )
                )
            }
        }
    }

    // =============================================================
    // SAVE STATUS TO GALLERY
    // =============================================================

    private fun saveStatusToGallery(
        sourceUri: Uri,
        originalName: String,
        mimeType: String
    ): Map<String, Any> {

        val isVideo =
            mimeType.startsWith(
                "video/"
            )

        val isImage =
            mimeType.startsWith(
                "image/"
            )

        if (!isVideo && !isImage) {
            throw Exception(
                "Unsupported media type: $mimeType"
            )
        }

        var fileName =
            originalName.trim()

        if (fileName.isEmpty()) {
            fileName =
                if (isVideo) {
                    "Status.mp4"
                } else {
                    "Status.jpg"
                }
        }

        fileName =
            fileName.replace(
                Regex(
                    "[\\\\/:*?\"<>|]"
                ),
                "_"
            )

        // =========================================================
        // ANDROID 10+
        // =========================================================

        if (
            Build.VERSION.SDK_INT >=
            Build.VERSION_CODES.Q
        ) {

            val collection =
                if (isVideo) {

                    MediaStore.Video.Media
                        .getContentUri(
                            MediaStore
                                .VOLUME_EXTERNAL_PRIMARY
                        )

                } else {

                    MediaStore.Images.Media
                        .getContentUri(
                            MediaStore
                                .VOLUME_EXTERNAL_PRIMARY
                        )
                }

            val relativePath =
                if (isVideo) {
                    "Movies/Status Saver"
                } else {
                    "Pictures/Status Saver"
                }

            // -----------------------------------------------------
            // DUPLICATE CHECK
            // -----------------------------------------------------

            val duplicate =
                findExistingMedia(
                    collection,
                    fileName,
                    relativePath
                )

            if (duplicate != null) {

                return mapOf(
                    "success" to true,
                    "alreadySaved" to true,
                    "uri" to
                            duplicate.toString(),
                    "name" to
                            fileName
                )
            }

            // -----------------------------------------------------
            // CREATE MEDIASTORE ENTRY
            // -----------------------------------------------------

            val values =
                ContentValues().apply {

                    put(
                        MediaStore.MediaColumns.DISPLAY_NAME,
                        fileName
                    )

                    put(
                        MediaStore.MediaColumns.MIME_TYPE,
                        mimeType
                    )

                    put(
                        MediaStore.MediaColumns.RELATIVE_PATH,
                        relativePath
                    )

                    put(
                        MediaStore.MediaColumns.IS_PENDING,
                        1
                    )
                }

            val destinationUri =
                contentResolver.insert(
                    collection,
                    values
                )

            if (destinationUri == null) {

                throw Exception(
                    "Unable to create gallery file"
                )
            }

            try {

                val inputStream =
                    contentResolver
                        .openInputStream(
                            sourceUri
                        )

                if (inputStream == null) {

                    throw Exception(
                        "Unable to read status file"
                    )
                }

                inputStream.use { input ->

                    contentResolver
                        .openOutputStream(
                            destinationUri
                        )?.use { output ->

                            input.copyTo(
                                output
                            )
                        }
                        ?: throw Exception(
                            "Unable to open gallery file"
                        )
                }

                val completedValues =
                    ContentValues().apply {

                        put(
                            MediaStore.MediaColumns.IS_PENDING,
                            0
                        )
                    }

                contentResolver.update(
                    destinationUri,
                    completedValues,
                    null,
                    null
                )

                return mapOf(
                    "success" to true,
                    "alreadySaved" to false,
                    "uri" to
                            destinationUri.toString(),
                    "name" to
                            fileName
                )

            } catch (e: Exception) {

                contentResolver.delete(
                    destinationUri,
                    null,
                    null
                )

                throw e
            }
        }

        // =========================================================
        // ANDROID 9 AND BELOW
        // =========================================================

        val collection =
            if (isVideo) {

                MediaStore.Video.Media
                    .EXTERNAL_CONTENT_URI

            } else {

                MediaStore.Images.Media
                    .EXTERNAL_CONTENT_URI
            }

        val values =
            ContentValues().apply {

                put(
                    MediaStore.MediaColumns.DISPLAY_NAME,
                    fileName
                )

                put(
                    MediaStore.MediaColumns.MIME_TYPE,
                    mimeType
                )
            }

        val destinationUri =
            contentResolver.insert(
                collection,
                values
            )

        if (destinationUri == null) {

            throw Exception(
                "Unable to create gallery file"
            )
        }

        try {

            val inputStream =
                contentResolver
                    .openInputStream(
                        sourceUri
                    )

            if (inputStream == null) {

                throw Exception(
                    "Unable to read status file"
                )
            }

            inputStream.use { input ->

                contentResolver
                    .openOutputStream(
                        destinationUri
                    )?.use { output ->

                        input.copyTo(
                            output
                        )
                    }
                    ?: throw Exception(
                        "Unable to open gallery file"
                    )
            }

            return mapOf(
                "success" to true,
                "alreadySaved" to false,
                "uri" to
                        destinationUri.toString(),
                "name" to
                        fileName
            )

        } catch (e: Exception) {

            contentResolver.delete(
                destinationUri,
                null,
                null
            )

            throw e
        }
    }

    // =============================================================
    // FIND DUPLICATE
    // =============================================================

    private fun findExistingMedia(
        collection: Uri,
        fileName: String,
        relativePath: String
    ): Uri? {

        val projection =
            arrayOf(
                MediaStore.MediaColumns._ID,
                MediaStore.MediaColumns.DISPLAY_NAME
            )

        val selection =
            "${MediaStore.MediaColumns.DISPLAY_NAME} = ? AND " +
                    "${MediaStore.MediaColumns.RELATIVE_PATH} = ?"

        val selectionArgs =
            arrayOf(
                fileName,
                "$relativePath/"
            )

        contentResolver.query(
            collection,
            projection,
            selection,
            selectionArgs,
            null
        )?.use { cursor ->

            val idColumn =
                cursor.getColumnIndex(
                    MediaStore.MediaColumns._ID
                )

            if (
                idColumn >= 0 &&
                cursor.moveToFirst()
            ) {

                val id =
                    cursor.getLong(
                        idColumn
                    )

                return Uri.withAppendedPath(
                    collection,
                    id.toString()
                )
            }
        }

        return null
    }

    // =============================================================
    // GUESS MIME TYPE
    // =============================================================

    private fun guessMimeType(
        fileName: String
    ): String {

        val lower =
            fileName.lowercase()

        return when {

            lower.endsWith(".mp4") ->
                "video/mp4"

            lower.endsWith(".3gp") ->
                "video/3gpp"

            lower.endsWith(".mkv") ->
                "video/x-matroska"

            lower.endsWith(".webm") ->
                "video/webm"

            lower.endsWith(".mov") ->
                "video/quicktime"

            lower.endsWith(".jpg") ||
                    lower.endsWith(".jpeg") ->
                "image/jpeg"

            lower.endsWith(".png") ->
                "image/png"

            lower.endsWith(".webp") ->
                "image/webp"

            else ->
                "application/octet-stream"
        }
    }

    // =============================================================
    // ACTIVITY RESULT
    // =============================================================

    @Deprecated(
        "Deprecated in Android API"
    )
    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?
    ) {

        super.onActivityResult(
            requestCode,
            resultCode,
            data
        )

        if (
            requestCode !=
            FOLDER_PICKER_REQUEST
        ) {
            return
        }

        val result =
            folderPickerResult

        val source =
            folderPickerSource

        folderPickerResult = null
        folderPickerSource = null

        if (
            resultCode !=
            Activity.RESULT_OK ||
            data == null
        ) {

            result?.success(false)

            return
        }

        val treeUri =
            data.data

        if (treeUri == null) {

            result?.success(false)

            return
        }

        if (
            source != "whatsapp" &&
            source != "business"
        ) {

            result?.success(false)

            return
        }

        // =========================================================
        // VERIFY .STATUSES
        // =========================================================

        val folderName =
            getDocumentDisplayName(
                treeUri
            )

        if (
            folderName == null ||
            !folderName.equals(
                ".Statuses",
                ignoreCase = true
            )
        ) {

            result?.success(false)

            return
        }

        // =========================================================
        // PERSIST PERMISSION
        // =========================================================

        try {

            contentResolver
                .takePersistableUriPermission(
                    treeUri,
                    Intent.FLAG_GRANT_READ_URI_PERMISSION or
                            Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                )

        } catch (
            e: SecurityException
        ) {

            e.printStackTrace()
        }

        // =========================================================
        // SOURCE-SPECIFIC STORAGE
        // =========================================================

        val preferenceKey =
            if (
                source == "business"
            ) {

                "whatsapp_business_status_folder_uri"

            } else {

                "whatsapp_status_folder_uri"
            }

        getSharedPreferences(
            "status_saver",
            MODE_PRIVATE
        )
            .edit()
            .putString(
                preferenceKey,
                treeUri.toString()
            )
            .apply()

        // =========================================================
        // REMEMBER SOURCE
        // =========================================================

        getSharedPreferences(
            "status_saver",
            MODE_PRIVATE
        )
            .edit()
            .putString(
                "last_selected_source",
                source
            )
            .apply()

        result?.success(true)
    }

    // =============================================================
    // CHECK INSTALLED PACKAGE
    // =============================================================

    @Suppress("DEPRECATION")
    private fun isPackageInstalled(
        packageName: String
    ): Boolean {

        return try {

            packageManager.getApplicationInfo(
                packageName,
                0
            )

            true

        } catch (
            e: PackageManager
            .NameNotFoundException
        ) {

            false
        }
    }

    // =============================================================
    // CHECK STORED FOLDER
    // =============================================================

    private fun hasStoredFolder(
        source: String
    ): Boolean {

        val key =
            if (
                source == "business"
            ) {

                "whatsapp_business_status_folder_uri"

            } else {

                "whatsapp_status_folder_uri"
            }

        val uri =
            getSharedPreferences(
                "status_saver",
                MODE_PRIVATE
            )
                .getString(
                    key,
                    null
                )

        return !uri.isNullOrEmpty()
    }

    // =============================================================
    // GET DOCUMENT DISPLAY NAME
    // =============================================================

    private fun getDocumentDisplayName(
        treeUri: Uri
    ): String? {

        return try {

            val documentUri =
                DocumentsContract
                    .buildDocumentUriUsingTree(
                        treeUri,
                        DocumentsContract
                            .getTreeDocumentId(
                                treeUri
                            )
                    )

            val projection =
                arrayOf(
                    DocumentsContract
                        .Document
                        .COLUMN_DISPLAY_NAME
                )

            contentResolver.query(
                documentUri,
                projection,
                null,
                null,
                null
            )?.use { cursor ->

                if (cursor.moveToFirst()) {

                    val column =
                        cursor.getColumnIndex(
                            DocumentsContract
                                .Document
                                .COLUMN_DISPLAY_NAME
                        )

                    if (column >= 0) {

                        cursor.getString(
                            column
                        )

                    } else {
                        null
                    }

                } else {
                    null
                }
            }

        } catch (e: Exception) {

            null
        }
    }

    // =============================================================
    // MIGRATE OLD FOLDER
    // =============================================================

    private fun migrateLegacyFolder() {

        val preferences =
            getSharedPreferences(
                "status_saver",
                MODE_PRIVATE
            )

        val oldUri =
            preferences.getString(
                "status_folder_uri",
                null
            )

        val newUri =
            preferences.getString(
                "whatsapp_status_folder_uri",
                null
            )

        if (
            !oldUri.isNullOrEmpty() &&
            newUri.isNullOrEmpty()
        ) {

            preferences
                .edit()
                .putString(
                    "whatsapp_status_folder_uri",
                    oldUri
                )
                .remove(
                    "status_folder_uri"
                )
                .putString(
                    "last_selected_source",
                    "whatsapp"
                )
                .apply()
        }
    }

    // =============================================================
    // CLEAN UP
    // =============================================================

    override fun onDestroy() {

        backgroundExecutor.shutdown()

        super.onDestroy()
    }
}