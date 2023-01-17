'use strict';
// @ts-nocheck
const vscode = require('vscode');
const customTagsDesc = require('./snippets/descriptions.json'); // açıklamaların bulunduğu json dosyası

/**
 * @param {vscode.ExtensionContext} context
 */

function getMessage(message, type) {
    if (type == "info") {
        vscode.window.showInformationMessage(message);
    } else if (type == "err"){
        vscode.window.showErrorMessage(message);
    } else {
        vscode.window.showWarningMessage(message);
    }
}



// HOVER BAŞLANGIÇ
vscode.languages.registerHoverProvider('cfml', {
    provideHover(document, position, token) {

        const range = document.getWordRangeAtPosition(position); // farenin üzerinde bulunduğu sözcüğün pozisyonunu alıyor
        const word = document.getText(range); // üstte alınan pozisyonda bulunan sözcüğü alıyor
        const hoverLast = new vscode.MarkdownString(customTagsDesc[word]); // Alınan açıklama metnini, markdown olarak yorumluyor.

        return new vscode.Hover(hoverLast);
        // hoverLast değişkeni ile alınan sözcüğe ait açıklamayı, descriptions.json dosyasından çekiyor
    }
});
// HOVER BİTİŞ




/* aktif satırdaki tagı kontrol ediyor BAŞLANGIÇ */
function checkTagContent() {
    const activeEditor = vscode.window.activeTextEditor;
    if (activeEditor) {
        let cursor = activeEditor.document.lineAt(activeEditor.selection.active.line); /* Geçerli satırı alır - current line */
        let cursorText = cursor.text.trim().split("<"); /* satırdaki boşluğu silip, satırı < işaretinden bölüyor */
        let cursorTextLastItem = cursorText[cursorText.length - 1]; /* bölünen satırdaki son tagı alıyor */
        let tagName = cursorTextLastItem.substr(0).split(" ")[0].split(">")[0]; /* son tagı boşluğa göre bölüp alıyor */
        
        
        
        if (cursor.text == "" | cursor.text == ">" | cursor.text == "/>") {
            getMessage("Tag ile aynı satırda olmanız gerekiyor!");
        }
        
        //getMessage("kullanılan tag: "+ tagName, "info");
        
        return tagName;    
        
    } else {
        getMessage("Aktif Sayfa Yok!", "err");
    }
}
/* aktif satırdaki tagı kontrol ediyor BİTİŞ */


/* snippet dosyasından sub prefix çekiyor BAŞLANGIÇ */
function callSnippet(lang, tag, sub) {
    vscode.commands.executeCommand("editor.action.insertSnippet", { langId: lang, name: tag + sub });
    /* tagName içeriğine göre, oluşturulan sub snippet'lerden birisi çalışacak */
}
/* snippet dosyasından sub prefix çekiyor BİTİŞ */



/* ana fonksiyon BAŞLANGIÇ */
function activate(context) {
    
    let disposable = vscode.commands.registerCommand('workcube-extension.cf_workcube', function () {
        //console.log("Extension etkinleştirildi!");

        let tagName = checkTagContent(); /* satırdaki tagı al */
        const htmlList = ['a', 'abbr', 'acronym', 'address', 'applet', 'area', 'article', 'aside', 'audio', 'b', 'base', 'basefont', 'bdi', 'bdo', 'big',
            'blockquote', 'body', 'br', 'button', 'canvas', 'caption', 'center', 'cite', 'code', 'col', 'colgroup', 'data', 'datalist', 'dd', 'del', 'details', 'dfn', 'dialog', 'dir', 'div', 'dl', 'dt', 'em', 'embed', 'fieldset', 'figcaption', 'figure', 'font', 'footer', 'form', 'frame', 'frameset', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head', 'header', 'hr', 'html', 'i', 'iframe', 'img', 'input', 'ins', 'kbd', 'label', 'legend', 'li', 'link', 'main', 'map', 'mark', 'meta', 'meter', 'nav', 'noframes', 'noscript', 'object', 'ol', 'optgroup', 'option', 'output', 'p', 'param', 'picture', 'pre', 'progress', 'q', 'rp', 'rt', 'ruby', 's', 'samp', 'script', 'section', 'select', 'small', 'source', 'span', 'strike', 'strong', 'style', 'sub', 'summary', 'sup', 'svg', 'table', 'tbody', 'td', 'template', 'textarea', 'tfoot', 'th', 'thead', 'time', 'title', 'tr', 'track', 'tt', 'u', 'ul', 'var', 'video', 'wbr']
        
        if (htmlList.includes(tagName)) {
            callSnippet("cfml", tagName, "_css"); // eğer tag html ise css snippet çağırılıyor
        }
        else {
            callSnippet("cfml", tagName, "_sub"); // eğer tag cfml-js ise customtag-js snippet çağırılıyor
        }

    });

    context.subscriptions.push(disposable);
}
/* ana fonksiyon BİTİŞ */


exports.activate = activate;

function deactivate() { }

module.exports = {
    activate,
    deactivate
}
