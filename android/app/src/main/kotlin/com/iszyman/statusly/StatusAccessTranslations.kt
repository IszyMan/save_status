package com.iszyman.statusly

import android.content.Context

object StatusAccessTranslations {

    private const val PREFS_NAME = "status_saver"
    private const val LANGUAGE_KEY = "selected_language"

    private fun language(
        context: Context
    ): String {

        val preferences =
            context.getSharedPreferences(
                PREFS_NAME,
                Context.MODE_PRIVATE
            )

        return preferences
            .getString(
                LANGUAGE_KEY,
                "en"
            )
            ?.lowercase()
            ?.substringBefore("-")
            ?: "en"
    }

    fun message(
        context: Context
    ): String {

        return when (language(context)) {

            "es" ->
                "Pulsa \"USAR ESTA CARPETA\" para guardar estados"

            "pt" ->
                "Toque em \"USAR ESTA PASTA\" para guardar estados"

            "de" ->
                "Drücke auf \"DIESEN ORDNER VERWENDEN\", um Statusmeldungen zu speichern"

            "fr" ->
                "Appuyez sur \"UTILISER CE DOSSIER\" pour enregistrer les statuts"

            else ->
                "Press \"USE THIS FOLDER\" to save statuses"
        }
    }

    fun button(
        context: Context
    ): String {

        return when (language(context)) {

            "es" ->
                "USAR ESTA CARPETA"

            "pt" ->
                "USAR ESTA PASTA"

            "de" ->
                "DIESEN ORDNER VERWENDEN"

            "fr" ->
                "UTILISER CE DOSSIER"

            else ->
                "USE THIS FOLDER"
        }
    }
}