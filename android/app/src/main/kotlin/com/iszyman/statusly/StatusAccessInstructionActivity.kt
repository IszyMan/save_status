package com.iszyman.statusly

import android.app.Activity
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView
import android.os.Handler
import android.os.Looper

class StatusAccessInstructionActivity : Activity() {

    private val dismissHandler = Handler(Looper.getMainLooper())

    private val dismissInstruction = Runnable {
        if (!isFinishing && !isDestroyed) {
            finish()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        window.setBackgroundDrawableResource(
            android.R.color.transparent
        )

        buildInstructionView()

        // Dismiss the guide after four seconds.
        // Android's actual folder picker remains open underneath.
        dismissHandler.postDelayed(
            dismissInstruction,
            4000L
        )
    }

    override fun onDestroy() {
        dismissHandler.removeCallbacks(dismissInstruction)
        super.onDestroy()
    }

    private fun buildInstructionView() {

        // =============================================================
        // ROOT
        // =============================================================

        val root =
            LinearLayout(this).apply {

                orientation =
                    LinearLayout.VERTICAL

                gravity =
                    Gravity.CENTER_HORIZONTAL

                setBackgroundColor(
                    Color.TRANSPARENT
                )

                setPadding(
                    20,
                    30,
                    20,
                    45
                )
            }

        // =============================================================
        // TOP SPACER
        // =============================================================

        val topSpacer =
            View(this)

        root.addView(
            topSpacer,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                0,
                1f
            )
        )

        // =============================================================
        // LIGHT INSTRUCTION PANEL
        // =============================================================

        val instructionPanel =
            LinearLayout(this).apply {

                orientation =
                    LinearLayout.VERTICAL

                gravity =
                    Gravity.CENTER_HORIZONTAL

                setPadding(
                    18,
                    18,
                    18,
                    22
                )

                background =
                    GradientDrawable().apply {

                        shape =
                            GradientDrawable.RECTANGLE

                        cornerRadius =
                            28f

                        setColor(
                            Color.argb(
                                225,
                                255,
                                255,
                                255
                            )
                        )
                    }

                elevation = 10f
            }

        val panelParams =
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )

        root.addView(
            instructionPanel,
            panelParams
        )

        // Move the white box slightly upward.
        instructionPanel.translationY = -35f

        // =============================================================
        // MESSAGE
        // =============================================================

        val message =
            TextView(this).apply {

                text =
                    StatusAccessTranslations.message(
                        this@StatusAccessInstructionActivity
                    )

                setTextColor(
                    Color.rgb(
                        35,
                        35,
                        35
                    )
                )

                textSize = 18f

                gravity =
                    Gravity.CENTER

                setTypeface(
                    null,
                    Typeface.BOLD
                )

                setPadding(
                    10,
                    4,
                    10,
                    10
                )
            }

        instructionPanel.addView(
            message,
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
        )

        // =============================================================
        // BUTTON + FINGER AREA
        // =============================================================

        val buttonContainer =
            FrameLayout(this).apply {

                clipChildren = false
                clipToPadding = false
            }

        val buttonContainerParams =
            LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                120
            )

        instructionPanel.addView(
            buttonContainer,
            buttonContainerParams
        )

        // =============================================================
        // FAKE USE THIS FOLDER BUTTON
        // =============================================================

        val fakeButton =
            TextView(this).apply {

                text =
                    StatusAccessTranslations.button(
                        this@StatusAccessInstructionActivity
                    )

                setTextColor(
                    Color.WHITE
                )

                textSize = 15f

                maxLines = 1

                setHorizontallyScrolling(false)

                gravity =
                    Gravity.CENTER

                setTypeface(
                    null,
                    Typeface.BOLD
                )

                background =
                    GradientDrawable().apply {

                        shape =
                            GradientDrawable.RECTANGLE

                        cornerRadius =
                            14f

                        setColor(
                            Color.rgb(
                                25,
                                103,
                                210
                            )
                        )
                    }

                setPadding(
                    16,
                    0,
                    16,
                    0
                )

                elevation = 8f

                setOnClickListener {

                    // This button only closes the instruction.
                    // Android's real button grants the folder permission.
                    finish()
                }
            }

        val buttonParams =
            FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                64
            ).apply {

                gravity =
                    Gravity.TOP

                leftMargin = 4
                rightMargin = 4
            }

        buttonContainer.addView(
            fakeButton,
            buttonParams
        )

        // =============================================================
        // FINGER
        //
        // The finger intentionally overlaps the button.
        //
        // About the upper half sits inside the button.
        // The lower half extends below it.
        // =============================================================

        val finger =
            TextView(this).apply {

                text = "☝️"

                textSize = 46f

                gravity =
                    Gravity.CENTER

                setShadowLayer(
                    6f,
                    0f,
                    2f,
                    Color.BLACK
                )

                setTextColor(
                    Color.rgb(
                        255,
                        214,
                        0
                    )
                )

                elevation = 20f

                // Prevent the emoji itself from receiving
                // unwanted click events.
                isClickable = false
            }

        val fingerParams =
            FrameLayout.LayoutParams(
                64,
                76
            ).apply {

                gravity =
                    Gravity.CENTER_HORIZONTAL

                // Button is 64dp high.
                // Finger starts at 38dp, meaning it overlaps
                // the lower part of the button and continues below.
                topMargin = 38
            }

        buttonContainer.addView(
            finger,
            fingerParams
        )

        // =============================================================
        // SHOW
        // =============================================================

        setContentView(root)

        // =============================================================
        // FINGER ANIMATION
        // =============================================================

        animateFinger(finger)
    }

    // =============================================================
    // FINGER ANIMATION
    // =============================================================

    private fun animateFinger(
        finger: TextView
    ) {

        // Gentle pressing motion.
        finger.animate()
            .translationY(5f)
            .setDuration(450)
            .withEndAction {

                finger.animate()
                    .translationY(0f)
                    .setDuration(450)
                    .withEndAction {

                        if (!isFinishing) {
                            animateFinger(finger)
                        }
                    }
                    .start()
            }
            .start()
    }
}