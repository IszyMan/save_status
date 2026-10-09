package com.iszyman.statusly

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

import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {

    private val CHANNEL =
        "com.iszyman.statusly/status"

    private val WHATSAPP_FOLDER_PICKER_REQUEST =
        1001

    private val BUSINESS_FOLDER_PICKER_REQUEST =
        1002

    // =============================================================
    // BACKGROUND EXECUTOR
    // =============================================================

    private val backgroundExecutor =
        Executors.newSingleThreadExecutor()

    private val mainHandler =
        Handler(Looper.getMainLooper())


    private var folderPickerResult: MethodChannel.Result? = null


    private val DELETE_SAVED_REQUEST = 9041

    private var pendingDeleteResult: MethodChannel.Result? = null
    private var pendingDeleteUri: Uri? = null
    private var retryDeleteAfterConsent = false


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
// SET APP LANGUAGE
// =====================================================

                "setAppLanguage" -> {

                    val language =
                        call.argument<String>("language")

                    if (language.isNullOrEmpty()) {

                        result.error(
                            "INVALID_LANGUAGE",
                            "Language code is missing",
                            null
                        )

                        return@setMethodCallHandler
                    }

                    val normalizedLanguage =
                        language
                            .lowercase()
                            .substringBefore("-")

                    val supportedLanguages =
                        setOf(
                            "en",
                            "es",
                            "fr",
                            "de",
                            "pt"
                        )

                    if (!supportedLanguages.contains(normalizedLanguage)) {

                        result.error(
                            "UNSUPPORTED_LANGUAGE",
                            "Unsupported language: $normalizedLanguage",
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
                            "selected_language",
                            normalizedLanguage
                        )
                        .apply()

                    Log.d(
                        "STATUS_DEBUG",
                        "Statusly language saved: $normalizedLanguage"
                    )

                    result.success(true)
                }

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
                // OPEN WHATSAPP
                // =====================================================

                "openWhatsApp" -> {
                    val source = call.argument<String>("source")

                    val packageName = when (source) {
                        "business", "WhatsApp Business" -> "com.whatsapp.w4b"
                        else -> "com.whatsapp"
                    }

                    val launchIntent =
                        packageManager.getLaunchIntentForPackage(packageName)

                    if (launchIntent != null) {
                        startActivity(launchIntent)
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }

                // =====================================================
                // SELECT STATUS FOLDER
                // =====================================================

                "selectStatusFolder" -> {

                    val source =
                        call.argument<String>("source") ?: "whatsapp"

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

                    folderPickerResult = result


                    val intent =
                        Intent(
                            Intent.ACTION_OPEN_DOCUMENT_TREE
                        )

                    // =========================================================
                    // BUILD THE INITIAL LOCATION
                    //
                    // IMPORTANT:
                    // Samsung DocumentsUI correctly opens the requested folder
                    // when Android/media is used as the TREE URI and the actual
                    // WhatsApp .Statuses folder is supplied as a DOCUMENT URI.
                    // =========================================================

                    val statusPath =
                        if (source == "business") {
                            "Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses"
                        } else {
                            "Android/media/com.whatsapp/WhatsApp/Media/.Statuses"
                        }

                    val statusDocumentId =
                        "primary:$statusPath"

                    val parentTreeUri =
                        try {

                            DocumentsContract.buildTreeDocumentUri(
                                "com.android.externalstorage.documents",
                                "primary:Android/media"
                            )

                        } catch (e: Exception) {

                            null
                        }

                    val initialUri =
                        try {

                            if (parentTreeUri != null) {

                                DocumentsContract.buildDocumentUriUsingTree(
                                    parentTreeUri,
                                    statusDocumentId
                                )

                            } else {

                                null
                            }

                        } catch (e: Exception) {

                            null
                        }


                    // =========================================================
                    // TELL ANDROID DOCUMENTSUI WHERE TO START
                    // =========================================================

                    if (
                        Build.VERSION.SDK_INT >=
                        Build.VERSION_CODES.O &&
                        initialUri != null
                    ) {

                        intent.putExtra(
                            DocumentsContract.EXTRA_INITIAL_URI,
                            initialUri
                        )
                    }

                    // =========================================================
                    // PERSISTABLE READ PERMISSION
                    // =========================================================

                    intent.addFlags(
                        Intent.FLAG_GRANT_READ_URI_PERMISSION or
                                Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION or
                                Intent.FLAG_GRANT_PREFIX_URI_PERMISSION
                    )

                    // =========================================================
                    // KEEP WHATSAPP AND WHATSAPP BUSINESS SEPARATE
                    // =========================================================

                    val requestCode =
                        if (source == "business") {
                            BUSINESS_FOLDER_PICKER_REQUEST
                        } else {
                            WHATSAPP_FOLDER_PICKER_REQUEST
                        }

                    startActivityForResult(
                        intent,
                        requestCode
                    )


                    // =========================================================
                    // SHOW OUR TRANSPARENT INSTRUCTION ABOVE DOCUMENTSUI
                    //
                    // IMPORTANT:
                    // This does NOT replace Android's folder picker.
                    // It only sits above it and explains what the user should
                    // press next.
                    // =========================================================

                    try {

                        val instructionIntent =
                            Intent(
                                this,
                                StatusAccessInstructionActivity::class.java
                            )

                        startActivity(
                            instructionIntent
                        )

                    } catch (e: Exception) {

                        Log.e(
                            "STATUS_DEBUG",
                            "Unable to show status access instruction overlay",
                            e
                        )
                    }
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


                "repostStatus" -> {
                    val uriString = call.argument<String>("uri")

                    if (uriString.isNullOrBlank()) {
                        result.error(
                            "INVALID_REPOST_URI",
                            "Nothing available to repost",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {
                        val mediaUri = Uri.parse(uriString)

                        if (mediaUri.scheme != "content") {
                            result.error(
                                "INVALID_REPOST_URI",
                                "A readable content URI is required",
                                null
                            )
                            return@setMethodCallHandler
                        }

                        val suppliedMime =
                            call.argument<String>("mimeType")

                        val mimeType =
                            contentResolver.getType(mediaUri)
                                ?: suppliedMime
                                    ?.takeIf {
                                        it.startsWith("image/") ||
                                                it.startsWith("video/")
                                    }
                                ?: "*/*"

                        val preferences = getSharedPreferences(
                            "status_saver",
                            MODE_PRIVATE
                        )

                        val lastSource = preferences.getString(
                            "last_selected_source",
                            "whatsapp"
                        )

                        val preferredPackage =
                            if (lastSource == "business") {
                                "com.whatsapp.w4b"
                            } else {
                                "com.whatsapp"
                            }

                        val fallbackPackage =
                            if (preferredPackage == "com.whatsapp") {
                                "com.whatsapp.w4b"
                            } else {
                                "com.whatsapp"
                            }

                        val targetPackage = when {
                            isPackageInstalled(preferredPackage) ->
                                preferredPackage

                            isPackageInstalled(fallbackPackage) ->
                                fallbackPackage

                            else -> null
                        }

                        if (targetPackage == null) {
                            result.error(
                                "WHATSAPP_NOT_INSTALLED",
                                "Install WhatsApp or WhatsApp Business to repost.",
                                null
                            )
                            return@setMethodCallHandler
                        }

                        val repostIntent = Intent(
                            Intent.ACTION_SEND
                        ).apply {
                            type = mimeType

                            setPackage(targetPackage)

                            putExtra(
                                Intent.EXTRA_STREAM,
                                mediaUri
                            )

                            clipData = android.content.ClipData.newUri(
                                contentResolver,
                                "Status",
                                mediaUri
                            )

                            addFlags(
                                Intent.FLAG_GRANT_READ_URI_PERMISSION
                            )
                        }

                        startActivity(repostIntent)

                        result.success(true)
                    } catch (e: Exception) {
                        Log.e(
                            "STATUS_DEBUG",
                            "Repost error",
                            e
                        )

                        result.error(
                            "REPOST_ERROR",
                            "Unable to open WhatsApp for this media.",
                            null
                        )
                    }
                }

                // DELETE SAVED STATUS
                "deleteSavedStatus" -> {
                    val uriString = call.argument<String>("uri")

                    if (pendingDeleteResult != null) {
                        result.error(
                            "DELETE_BUSY",
                            "Another deletion is already in progress.",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    if (uriString.isNullOrBlank()) {
                        result.error(
                            "INVALID_DELETE_URI",
                            "The saved item is missing.",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {
                        val uri = Uri.parse(uriString)

                        // Only allow deletion of items currently listed in Saved.
                        // This excludes WhatsApp's original status folder.
                        val isSavedMedia =
                            uri.scheme == "content" &&
                                    uri.authority == "media" &&
                                    getSavedStatusesFromGallery().any {
                                        it["uri"] == uriString
                                    }

                        if (!isSavedMedia) {
                            result.error(
                                "INVALID_SAVED_ITEM",
                                "This item is no longer available in Saved.",
                                null
                            )
                            return@setMethodCallHandler
                        }

                        try {
                            val removed = contentResolver.delete(
                                uri,
                                null,
                                null
                            )

                            result.success(removed > 0)
                        } catch (e: SecurityException) {
                            val request = when {
                                Build.VERSION.SDK_INT >= Build.VERSION_CODES.R -> {
                                    retryDeleteAfterConsent = false

                                    MediaStore.createDeleteRequest(
                                        contentResolver,
                                        listOf(uri)
                                    )
                                }

                                Build.VERSION.SDK_INT == Build.VERSION_CODES.Q &&
                                        e is android.app.RecoverableSecurityException -> {
                                    retryDeleteAfterConsent = true

                                    e.userAction.actionIntent
                                }

                                else -> throw e
                            }

                            pendingDeleteResult = result
                            pendingDeleteUri = uri

                            startIntentSenderForResult(
                                request.intentSender,
                                DELETE_SAVED_REQUEST,
                                null,
                                0,
                                0,
                                0
                            )
                        }
                    } catch (e: Exception) {
                        pendingDeleteResult = null
                        pendingDeleteUri = null
                        retryDeleteAfterConsent = false

                        result.error(
                            "DELETE_ERROR",
                            e.message ?: "Unable to delete this saved item.",
                            null
                        )
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
                                        ByteArrayOutputStream()

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
    ): List<Map<String, Any?>> {

        val preferenceKey =
            if (source == "business") {
                "whatsapp_business_status_folder_uri"
            } else {
                "whatsapp_status_folder_uri"
            }

        val storedUriString =
            getSharedPreferences(
                "status_saver",
                MODE_PRIVATE
            ).getString(
                preferenceKey,
                null
            ) ?: return emptyList()

        val treeUri =
            Uri.parse(storedUriString)

        // ============================================================
        // VERIFY THAT THIS IS THE CORRECT .STATUSES FOLDER
        // ============================================================

        val documentId =
            try {
                DocumentsContract.getTreeDocumentId(
                    treeUri
                )
            } catch (e: Exception) {
                return emptyList()
            }

        val decodedDocumentId =
            Uri.decode(
                documentId
            )
                .replace("\\", "/")
                .lowercase()

        val isCorrectStatusesFolder =
            if (source == "business") {

                decodedDocumentId.contains(
                    "android/media/com.whatsapp.w4b/"
                ) &&
                        decodedDocumentId.endsWith(
                            "/.statuses"
                        )

            } else {

                decodedDocumentId.contains(
                    "android/media/com.whatsapp/"
                ) &&
                        !decodedDocumentId.contains(
                            "android/media/com.whatsapp.w4b/"
                        ) &&
                        decodedDocumentId.endsWith(
                            "/.statuses"
                        )
            }

        if (!isCorrectStatusesFolder) {
            return emptyList()
        }

        // ============================================================
        // QUERY ONLY THE CHILDREN OF THE AUTHORIZED .STATUSES FOLDER
        // ============================================================

        val childrenUri =
            try {
                DocumentsContract
                    .buildChildDocumentsUriUsingTree(
                        treeUri,
                        documentId
                    )
            } catch (e: Exception) {
                return emptyList()
            }

        val results =
            mutableListOf<Map<String, Any?>>()

        val projection =
            arrayOf(
                DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                DocumentsContract.Document.COLUMN_DISPLAY_NAME,
                DocumentsContract.Document.COLUMN_MIME_TYPE,
                DocumentsContract.Document.COLUMN_LAST_MODIFIED
            )

        try {

            contentResolver.query(
                childrenUri,
                projection,
                null,
                null,
                "${DocumentsContract.Document.COLUMN_LAST_MODIFIED} DESC"
            )?.use { cursor ->

                val documentIdIndex =
                    cursor.getColumnIndex(
                        DocumentsContract.Document.COLUMN_DOCUMENT_ID
                    )

                val displayNameIndex =
                    cursor.getColumnIndex(
                        DocumentsContract.Document.COLUMN_DISPLAY_NAME
                    )

                val mimeTypeIndex =
                    cursor.getColumnIndex(
                        DocumentsContract.Document.COLUMN_MIME_TYPE
                    )

                val lastModifiedIndex =
                    cursor.getColumnIndex(
                        DocumentsContract.Document.COLUMN_LAST_MODIFIED
                    )

                while (cursor.moveToNext()) {

                    if (
                        documentIdIndex < 0 ||
                        displayNameIndex < 0 ||
                        mimeTypeIndex < 0
                    ) {
                        continue
                    }

                    val childDocumentId =
                        cursor.getString(
                            documentIdIndex
                        )

                    val displayName =
                        cursor.getString(
                            displayNameIndex
                        ) ?: continue

                    val mimeType =
                        cursor.getString(
                            mimeTypeIndex
                        ) ?: continue

                    val lastModified =
                        if (lastModifiedIndex >= 0) {
                            cursor.getLong(
                                lastModifiedIndex
                            )
                        } else {
                            0L
                        }

                    // Only images and videos.
                    if (
                        !mimeType.startsWith("image/") &&
                        !mimeType.startsWith("video/")
                    ) {
                        continue
                    }

                    val documentUri =
                        DocumentsContract
                            .buildDocumentUriUsingTree(
                                treeUri,
                                childDocumentId
                            )

                    results.add(
                        mapOf(
                            "name" to displayName,
                            "uri" to documentUri.toString(),
                            "mimeType" to mimeType,
                            "lastModified" to lastModified
                        )
                    )
                }
            }

        } catch (e: Exception) {

            Log.e(
                "STATUS_DEBUG",
                "Unable to load WhatsApp statuses",
                e
            )
        }

        return results
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

    // =============================================================
// ACTIVITY RESULT
// =============================================================

    @Deprecated("Deprecated in Android API")
    override fun onActivityResult(
        requestCode: Int,
        resultCode: Int,
        data: Intent?
    ) {
        Log.d(
            "STATUS_LIFECYCLE",
            "SAF onActivityResult | " +
                    "instance=${System.identityHashCode(this)} | " +
                    "requestCode=$requestCode | " +
                    "resultCode=$resultCode | " +
                    "dataUri=${data?.data} | " +
                    "dataFlags=${data?.flags} | " +
                    "folderPickerResultExists=${folderPickerResult != null}"
        )

        super.onActivityResult(
            requestCode,
            resultCode,
            data
        )

        if (requestCode == DELETE_SAVED_REQUEST) {
            val callback = pendingDeleteResult
            val uri = pendingDeleteUri
            val shouldRetry = retryDeleteAfterConsent

            pendingDeleteResult = null
            pendingDeleteUri = null
            retryDeleteAfterConsent = false

            if (callback == null) return

            if (resultCode != Activity.RESULT_OK || uri == null) {
                callback.success(false)
                return
            }

            try {
                if (shouldRetry) {
                    // Android 10 grants permission; we then delete.
                    val removed = contentResolver.delete(
                        uri,
                        null,
                        null
                    )

                    callback.success(removed > 0)
                } else {
                    // Android 11+ performs deletion through its prompt.
                    val stillExists = contentResolver.query(
                        uri,
                        arrayOf(MediaStore.MediaColumns._ID),
                        null,
                        null,
                        null
                    )?.use { cursor ->
                        cursor.moveToFirst()
                    } ?: false

                    callback.success(!stillExists)
                }
            } catch (e: Exception) {
                callback.error(
                    "DELETE_ERROR",
                    e.message ?: "Unable to finish deleting this item.",
                    null
                )
            }

            return
        }

        val source =
            when (requestCode) {
                WHATSAPP_FOLDER_PICKER_REQUEST ->
                    "whatsapp"

                BUSINESS_FOLDER_PICKER_REQUEST ->
                    "business"

                else ->
                    return
            }

        /*
         * Keep a local reference to the Flutter callback.
         *
         * This can be null if Android recreated MainActivity while
         * DocumentsUI was open. A null callback must not prevent us
         * from saving the selected folder permission.
         */
        val flutterResult =
            folderPickerResult

        folderPickerResult = null

        if (flutterResult == null) {
            Log.w(
                "STATUS_DEBUG",
                "Flutter callback was lost, but the SAF result will still be processed. " +
                        "source=$source"
            )
        }

        if (resultCode != Activity.RESULT_OK) {
            Log.d(
                "STATUS_DEBUG",
                "Folder picker cancelled. source=$source"
            )

            flutterResult?.success(false)
            return
        }

        val treeUri =
            data?.data

        if (treeUri == null) {
            Log.e(
                "STATUS_DEBUG",
                "Folder picker returned RESULT_OK but URI was null. source=$source"
            )

            flutterResult?.success(false)
            return
        }

        Log.d(
            "STATUS_DEBUG",
            "Selected folder. source=$source uri=$treeUri"
        )

        // =========================================================
        // VERIFY THAT THE SELECTED FOLDER IS .STATUSES
        // =========================================================

        val displayName =
            try {
                DocumentsContract
                    .getTreeDocumentId(treeUri)
                    .substringAfterLast("/")
                    .substringAfterLast(":")
            } catch (e: Exception) {
                Log.e(
                    "STATUS_DEBUG",
                    "Could not determine selected folder name",
                    e
                )

                ""
            }

        if (
            !displayName.equals(
                ".Statuses",
                ignoreCase = true
            )
        ) {
            Log.e(
                "STATUS_DEBUG",
                "Rejected folder because it is not .Statuses. " +
                        "source=$source uri=$treeUri"
            )

            flutterResult?.success(false)
            return
        }

        // =========================================================
        // VERIFY WHATSAPP OR WHATSAPP BUSINESS PATH
        // =========================================================

        val documentId =
            try {
                DocumentsContract.getTreeDocumentId(
                    treeUri
                )
            } catch (e: Exception) {
                Log.e(
                    "STATUS_DEBUG",
                    "Could not read tree document ID",
                    e
                )

                flutterResult?.success(false)
                return
            }

        val normalizedDocumentId =
            documentId
                .replace("\\", "/")
                .lowercase()

        val isCorrectSource =
            if (source == "business") {
                normalizedDocumentId.contains(
                    "android/media/com.whatsapp.w4b/"
                ) &&
                        normalizedDocumentId.endsWith(
                            "/.statuses"
                        )
            } else {
                normalizedDocumentId.contains(
                    "android/media/com.whatsapp/"
                ) &&
                        !normalizedDocumentId.contains(
                            "android/media/com.whatsapp.w4b/"
                        ) &&
                        normalizedDocumentId.endsWith(
                            "/.statuses"
                        )
            }

        if (!isCorrectSource) {
            Log.e(
                "STATUS_DEBUG",
                "Rejected wrong source folder. " +
                        "source=$source documentId=$documentId"
            )

            flutterResult?.success(false)
            return
        }

        // =========================================================
        // PERSIST READ PERMISSION
        // =========================================================

        try {
            val takeFlags =
                data.flags and
                        (
                                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                                        Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                                )

            val readFlags =
                takeFlags and
                        Intent.FLAG_GRANT_READ_URI_PERMISSION

            if (readFlags == 0) {
                Log.e(
                    "STATUS_DEBUG",
                    "Android did not return read permission. " +
                            "source=$source flags=${data.flags}"
                )

                flutterResult?.success(false)
                return
            }

            contentResolver.takePersistableUriPermission(
                treeUri,
                readFlags
            )
        } catch (e: Exception) {
            Log.e(
                "STATUS_DEBUG",
                "Could not persist folder permission. " +
                        "source=$source uri=$treeUri",
                e
            )

            flutterResult?.success(false)
            return
        }

        // =========================================================
        // SAVE CONFIGURATION
        // =========================================================

        val preferenceKey =
            if (source == "business") {
                "whatsapp_business_status_folder_uri"
            } else {
                "whatsapp_status_folder_uri"
            }

        val saved =
            getSharedPreferences(
                "status_saver",
                MODE_PRIVATE
            )
                .edit()
                .putString(
                    preferenceKey,
                    treeUri.toString()
                )
                .putString(
                    "last_selected_source",
                    source
                )
                .commit()

        if (!saved) {
            Log.e(
                "STATUS_DEBUG",
                "Failed to save folder URI to SharedPreferences. " +
                        "source=$source"
            )

            flutterResult?.success(false)
            return
        }

        Log.d(
            "STATUS_DEBUG",
            "Saved folder successfully. " +
                    "source=$source key=$preferenceKey uri=$treeUri " +
                    "flutterCallbackAvailable=${flutterResult != null}"
        )

        logPersistedUriPermissions()

        /*
         * If Flutter survived, complete its pending Future normally.
         * If Flutter restarted, the configuration has still been saved
         * and getAppState() will detect it during startup.
         */
        flutterResult?.success(true)
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

        if (uriString.isNullOrEmpty()) {
            Log.d(
                "STATUS_DEBUG",
                "No stored folder for source=$source"
            )
            return false
        }

        val treeUri =
            try {
                Uri.parse(uriString)
            } catch (e: Exception) {
                Log.e(
                    "STATUS_DEBUG",
                    "Invalid stored URI for source=$source",
                    e
                )
                return false
            }

        val hasPersistedPermission =
            contentResolver.persistedUriPermissions.any {
                it.uri == treeUri &&
                        it.isReadPermission
            }

        if (!hasPersistedPermission) {
            Log.e(
                "STATUS_DEBUG",
                "Stored URI has no persisted read permission. " +
                        "source=$source uri=$treeUri"
            )
            return false
        }

        val documentId =
            try {
                DocumentsContract.getTreeDocumentId(
                    treeUri
                )
            } catch (e: Exception) {
                Log.e(
                    "STATUS_DEBUG",
                    "Could not read stored document ID for source=$source",
                    e
                )
                return false
            }

        val normalizedDocumentId =
            documentId
                .replace("\\", "/")
                .lowercase()

        val correctPath =
            if (source == "business") {
                normalizedDocumentId.contains(
                    "android/media/com.whatsapp.w4b/"
                ) &&
                        normalizedDocumentId.endsWith(
                            "/.statuses"
                        )
            } else {
                normalizedDocumentId.contains(
                    "android/media/com.whatsapp/"
                ) &&
                        !normalizedDocumentId.contains(
                            "android/media/com.whatsapp.w4b/"
                        ) &&
                        normalizedDocumentId.endsWith(
                            "/.statuses"
                        )
            }

        if (!correctPath) {
            Log.e(
                "STATUS_DEBUG",
                "Stored folder has wrong path. " +
                        "source=$source documentId=$documentId"
            )
            return false
        }

        Log.d(
            "STATUS_DEBUG",
            "Stored folder is valid. " +
                    "source=$source uri=$treeUri"
        )

        return true
    }





    private fun logPersistedUriPermissions() {
        try {
            val permissions =
                contentResolver.persistedUriPermissions

            for (permission in permissions) {
                Log.d(
                    "STATUS_DEBUG",
                    "Persisted URI: ${permission.uri} " +
                            "read=${permission.isReadPermission} " +
                            "write=${permission.isWritePermission}"
                )
            }
        } catch (e: Exception) {
            Log.e(
                "STATUS_DEBUG",
                "Could not read persisted URI permissions",
                e
            )
        }
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



    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        Log.d(
            "STATUS_LIFECYCLE",
            "MainActivity onCreate | " +
                    "instance=${System.identityHashCode(this)} | " +
                    "savedInstanceState=${savedInstanceState != null} | " +
                    "folderPickerResultExists=${folderPickerResult != null}"
        )
    }

    override fun onStart() {
        super.onStart()

        Log.d(
            "STATUS_LIFECYCLE",
            "MainActivity onStart | " +
                    "instance=${System.identityHashCode(this)} | " +
                    "folderPickerResultExists=${folderPickerResult != null}"
        )
    }

    override fun onResume() {
        super.onResume()

        Log.d(
            "STATUS_LIFECYCLE",
            "MainActivity onResume | " +
                    "instance=${System.identityHashCode(this)} | " +
                    "folderPickerResultExists=${folderPickerResult != null}"
        )
    }

    override fun onPause() {
        Log.d(
            "STATUS_LIFECYCLE",
            "MainActivity onPause | " +
                    "instance=${System.identityHashCode(this)} | " +
                    "folderPickerResultExists=${folderPickerResult != null}"
        )

        super.onPause()
    }

    override fun onStop() {
        Log.d(
            "STATUS_LIFECYCLE",
            "MainActivity onStop | " +
                    "instance=${System.identityHashCode(this)} | " +
                    "folderPickerResultExists=${folderPickerResult != null}"
        )

        super.onStop()
    }

    // =============================================================
    // CLEAN UP
    // =============================================================

    override fun onDestroy() {

        Log.e(
            "STATUS_LIFECYCLE",
            "MainActivity onDestroy | " +
                    "instance=${System.identityHashCode(this)} | " +
                    "folderPickerResultExists=${folderPickerResult != null}"
        )

        backgroundExecutor.shutdown()

        super.onDestroy()
    }
}