package com.example.status_saver

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.provider.DocumentsContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.status_saver/status"
    private val FOLDER_PICKER_REQUEST = 1001

    private var folderPickerResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "selectStatusFolder" -> {

                    folderPickerResult = result

                    val intent = Intent(
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

                "getStatuses" -> {

                    val statuses = getSavedStatuses()

                    result.success(statuses)
                }

                "readStatus" -> {

                    val uriString = call.argument<String>("uri")

                    if (uriString == null) {
                        result.error(
                            "INVALID_URI",
                            "Status URI is missing",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    try {

                        val uri = Uri.parse(uriString)

                        val bytes = contentResolver.openInputStream(uri)
                            ?.use { inputStream ->
                                inputStream.readBytes()
                            }

                        if (bytes == null) {
                            result.error(
                                "READ_ERROR",
                                "Unable to read status file",
                                null
                            )
                        } else {
                            result.success(bytes)
                        }

                    } catch (e: Exception) {

                        result.error(
                            "READ_ERROR",
                            e.message,
                            null
                        )
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    @Deprecated("Deprecated in Android API")
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

        if (requestCode != FOLDER_PICKER_REQUEST) {
            return
        }

        if (
            resultCode != Activity.RESULT_OK ||
            data == null
        ) {
            folderPickerResult?.success(false)
            folderPickerResult = null
            return
        }

        val treeUri = data.data

        if (treeUri == null) {
            folderPickerResult?.success(false)
            folderPickerResult = null
            return
        }

        try {

            contentResolver.takePersistableUriPermission(
                treeUri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                        Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            )

        } catch (e: SecurityException) {

            e.printStackTrace()
        }

        getSharedPreferences(
            "status_saver",
            MODE_PRIVATE
        )
            .edit()
            .putString(
                "status_folder_uri",
                treeUri.toString()
            )
            .apply()

        folderPickerResult?.success(true)
        folderPickerResult = null
    }

    private fun getSavedStatuses(): List<Map<String, String>> {

        val preferences = getSharedPreferences(
            "status_saver",
            MODE_PRIVATE
        )

        val uriString = preferences.getString(
            "status_folder_uri",
            null
        )

        if (uriString == null) {
            return emptyList()
        }

        val treeUri = Uri.parse(uriString)

        val statuses = mutableListOf<Map<String, String>>()

        val childrenUri =
            DocumentsContract.buildChildDocumentsUriUsingTree(
                treeUri,
                DocumentsContract.getTreeDocumentId(treeUri)
            )

        val projection = arrayOf(
            DocumentsContract.Document.COLUMN_DOCUMENT_ID,
            DocumentsContract.Document.COLUMN_DISPLAY_NAME,
            DocumentsContract.Document.COLUMN_MIME_TYPE,
            DocumentsContract.Document.COLUMN_LAST_MODIFIED
        )

        contentResolver.query(
            childrenUri,
            projection,
            null,
            null,
            "${DocumentsContract.Document.COLUMN_LAST_MODIFIED} DESC"
        )?.use { cursor ->

            val idColumn = cursor.getColumnIndex(
                DocumentsContract.Document.COLUMN_DOCUMENT_ID
            )

            val nameColumn = cursor.getColumnIndex(
                DocumentsContract.Document.COLUMN_DISPLAY_NAME
            )

            val mimeColumn = cursor.getColumnIndex(
                DocumentsContract.Document.COLUMN_MIME_TYPE
            )

            val modifiedColumn = cursor.getColumnIndex(
                DocumentsContract.Document.COLUMN_LAST_MODIFIED
            )

            while (cursor.moveToNext()) {

                val documentId = cursor.getString(
                    idColumn
                )

                val name = cursor.getString(
                    nameColumn
                )

                val mimeType = cursor.getString(
                    mimeColumn
                )

                val lastModified =
                    if (
                        modifiedColumn >= 0 &&
                        !cursor.isNull(modifiedColumn)
                    ) {
                        cursor.getLong(
                            modifiedColumn
                        ).toString()
                    } else {
                        "0"
                    }

                if (
                    mimeType.startsWith("image/") ||
                    mimeType.startsWith("video/")
                ) {

                    val documentUri =
                        DocumentsContract.buildDocumentUriUsingTree(
                            treeUri,
                            documentId
                        )

                    statuses.add(
                        mapOf(
                            "name" to name,
                            "uri" to documentUri.toString(),
                            "mimeType" to mimeType,
                            "lastModified" to lastModified
                        )
                    )
                }
            }
        }

        return statuses
    }
}