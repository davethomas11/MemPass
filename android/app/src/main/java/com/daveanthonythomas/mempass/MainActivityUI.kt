package com.daveanthonythomas.mempass

import android.text.InputType
import android.view.Gravity
import android.view.KeyEvent
import android.view.inputmethod.EditorInfo
import org.jetbrains.anko.*
import org.jetbrains.anko.appcompat.v7.toolbar
import org.jetbrains.anko.design.appBarLayout
import org.jetbrains.anko.design.coordinatorLayout

/**
 * Created by dave on 2016-07-20.
 */
class MainActivityUI : AnkoComponent<MainActivity>  {

    override fun createView(ui: AnkoContext<MainActivity>) = with(ui) {

        coordinatorLayout {

            appBarLayout(theme = R.style.AppTheme_AppBarOverlay) {

                ui.owner.setSupportActionBar(toolbar {

                    popupTheme = R.style.AppTheme_PopupOverlay
                }.lparams(width = matchParent))

            }.lparams(width = matchParent)

            relativeLayout {

                padding = dip(16)

                val mEditText = editText {
                    hint = "Enter a simple phrase"
                    inputType = InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_VARIATION_PASSWORD
                    gravity = Gravity.CENTER
                    imeOptions = EditorInfo.IME_ACTION_DONE



                }.lparams { centerInParent() }

                mEditText.setOnEditorActionListener { textView, i, keyEvent ->

                    if (i == EditorInfo.IME_ACTION_DONE || keyEvent.keyCode == KeyEvent.KEYCODE_ENTER) {
                        ui.owner.MemPass(textView.text.toString())
                    }

                    false
                }

            }.lparams(width = matchParent, height = matchParent)
        }
    }

}