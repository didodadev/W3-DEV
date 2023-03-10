/*
 * kothing-editor.js
 * Copyright Kothing
 * MIT license.
 */
'use strict';

export default {
    name: 'notice',
    add: function (core) {
        const context = core.context;
        context.notice = {};

        /** dialog */
        let notice_div = core.util.createElement('DIV');
        const notice_span = core.util.createElement('SPAN');
        const notice_button = core.util.createElement('BUTTON');

        notice_div.className = 'ke-notice';
        notice_button.className = 'close';
        notice_button.setAttribute('aria-label', 'Close');
        notice_button.setAttribute('title', core.lang.dialogBox.close);
        notice_button.innerHTML = '<i aria-hidden="true" data-command="close" class="ke-icon-cancel"></i>';
        
        notice_div.appendChild(notice_span);
        notice_div.appendChild(notice_button);

        context.notice.modal = notice_div;
        context.notice.message = notice_span;

        /** add event listeners */
        notice_button.addEventListener('click', this.onClick_cancel.bind(core));
        
        /** append html */
        context.element.editorArea.insertBefore(notice_div, context.element.wysiwygFrame);
        
        /** empty memory */
        notice_div = null;
    },

    onClick_cancel: function (e) {
        e.preventDefault();
        e.stopPropagation();
        this.plugins.notice.close.call(this);
    },

    open: function (text)  {
        this.context.notice.message.textContent = text;
        this.context.notice.modal.style.display = 'block';
    },

    close: function () {
        this.context.notice.modal.style.display = 'none';
    }
};
