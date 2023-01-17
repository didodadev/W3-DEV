<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<style type="text/css">
  BODY {
  	margin: 0pt;
  	padding: 0pt;
  	border: none;
  	background-color : #FFF;
  }
  IFRAME {width: 100%; height: 100%; border: none;}
</style>

<script language=`JavaScript`>
var rightCaret = String.fromCharCode (62);
function isEditable (selectionRange)
	{
	/*Return true if the selection is in an editable part of the page -- in the textarea.*/
	if ((selectionRange.parentElement ().tagName == "TEXTAREA") || (selectionRange.parentElement ().tagName == "BODY"))
		return true;
	return false;
	} /*isEditable*/

function getSelectionRange()
	{
	/*Get a reference to the current selection range.
	If there is no selection range, or it`s not in a textarea, return null.*/
	var selectionRange;
	selectionRange = textEdit.document.selection.createRange();
	var currentText = selectionRange.text;
	if (currentText != "")
		return (selectionRange);
	return (null);
	} /*getSelectionRange*/

function highlightButton(buttonRef)
	{
	/*Highlight the button only if there is currently editable text.*/
	var selectionRange;
	selectionRange = getSelectionRange();
	if (selectionRange == null)
		{
		buttonRef.style.cursor = "default";
		return false;
		}
	buttonRef.style.color = "maroon";
	/*buttonRef.style.cursor = "hand";*/
	buttonRef.style.cursor = "default";
	return true;
	} /*highlightButton*/

function unHighlightButton(buttonRef)
	{
	/*Unhighlight a button.*/
	buttonRef.style.color = "black";
	return true;
	} /*unHighlightButton*/

function urlPrompt()
	{
	/*Prompt the user via dialog box for a URL.*/
	var url;
	url = prompt ("URL:", "http://");
	return (url);
	} /*urlPrompt*/

function replaceText(selectionRange, preText, postText, currentText)
	{
	/*Enclose the selected text with preText and postText.*/
	var txt = textEdit.document.body.innerHTML;
	var fi = txt.indexOf(currentText);
	var li = fi + currentText.length;
	var ind = txt.indexOf("<FONT");

	while((ind != -1) && (txt.indexOf(" size=",ind) <= (ind + 21))){
		if((fi != -1) && (ind >= (fi - 14)))
			{
			fi = ind;
			li += 7;
			break;
			}
		else
			ind = txt.indexOf("<FONT",ind + 1);
	}	
	/*alert(fi + " - " + li + " - " + txt.indexOf("<FONT"));*/
	textEdit.document.body.innerHTML = txt.substring(0,fi) + preText + currentText + postText + txt.substring(li,txt.length);
	selectionRange.parentElement ().focus();
} /*replaceText*/


function simpleEnclose(tagName)
	{
	/*Enclose selected text with a tag and closing tag.*/
	if (tagName == "")
		return false;
	var selectionRange;
	selectionRange = getSelectionRange();
	if (selectionRange != null)
		{
		var currentText;
		currentText = selectionRange.text;
		var preText, postText;
		preText = "<" + tagName + rightCaret;
		postText = "</" + tagName + rightCaret;
		replaceText (selectionRange, preText, postText, currentText);
		}
	} /*simpleEnclose*/

function addFormat(tagName)
	{
	/*Handle tags in the Format menu.*/
	if (tagName == "") return false;
	var selectionRange;
	selectionRange = getSelectionRange();
	if (selectionRange != null)
		{
		var currentText;
		currentText = selectionRange.text;
		var preText, postText;
		preText = "<" + tagName + rightCaret;
		postText = "</" + tagName + rightCaret;

		if (tagName == "blockquote")
			{
			preText = "	" + preText;
			postText = postText + " ";
			}
		if (tagName == "li")
			{
			preText = "<li" + rightCaret;
			postText = " ";
			}
		replaceText (selectionRange, preText, postText, currentText);
		}
	} /*addFormat*/

function addFontColor (colorName)
	{
	/*Enclose the selected text with a font tag that specifies the color*/
	if (colorName == "") return false;
	var selectionRange;
	selectionRange = getSelectionRange();
	if (selectionRange != null)
		{
		var currentText;
		currentText = selectionRange.text;
		var preText, postText;
		preText = "<FONT color=\"" + colorName + "\"" + rightCaret;
		postText = "</FONT" + rightCaret;
		replaceText(selectionRange, preText, postText, currentText);
		}
	} /*addFontColor*/

function addFontFace(faceName)
	{
	/*Enclose the selected text with a font tag that specifies the font face.*/
	if (faceName == "")	return false;
	var selectionRange;
	selectionRange = getSelectionRange();
	if (selectionRange != null)
		{
		var currentText;
		currentText = selectionRange.text;
		var preText, postText;
		preText = "<FONT face=\"" + faceName + "\"" + rightCaret;
		postText = "</FONT" + rightCaret;
		replaceText (selectionRange, preText, postText, currentText);
		}
	} /*addFontFace*/
	
function addFontSize(size)
	{
	/*Enclose the selected text with a font tag that specifies the font face.*/
	if (size == "")	return false;
	var selectionRange;
	selectionRange = getSelectionRange();
	if (selectionRange != null)
		{
		var currentText;
		currentText = selectionRange.text;
		var preText, postText;
		var ind , cind;
		if(size.indexOf("+") != -1){
			ind = textEdit.document.body.innerHTML.indexOf("size=");
			cind = textEdit.document.body.innerHTML.indexOf(currentText);
			size = size.substr(1);
			while(ind != -1){
				if(ind >= (cind - 11)){
					ind += 5;
					cind = textEdit.document.body.innerHTML.indexOf(">",ind);
					ind = Number(textEdit.document.body.innerHTML.substring(ind,cind)) + Number(size);
					size = ind.toString();
					break;
				}
				else
					ind = textEdit.document.body.innerHTML.indexOf("size=",ind + 1);
			}
			
		}	
		preText = "<FONT size=" + size + rightCaret;
		postText = "</FONT" + rightCaret;
		replaceText (selectionRange, preText, postText, currentText);
		/*alert(preText + ' - ' + postText + ' - ' + textEdit.document.body.innerHTML + ' - ' + currentText);*/
		}
	} /*addFontSize	*/


function addAlignment (alignment)
	{
	/*Enclose the selected text with a font tag that specifies the color*/
	if (alignment == "") return false;
	var selectionRange;
	selectionRange = getSelectionRange();
	if (selectionRange != null)
		{
		var currentText;
		currentText = selectionRange.text;
		var preText, postText;
		preText = "<p align=\"" + alignment + "\"" + rightCaret;
		postText = "</p" + rightCaret + " ";
		replaceText (selectionRange, preText, postText, currentText);
		}
	} /*addAlignment*/

function addLink ()
	{
	/*Prompt the user for a URL and make the selection a link.*/
	var selectionRange;
	selectionRange = getSelectionRange();
	if (selectionRange != null)
		{
		var currentText;
		currentText = selectionRange.text;
		var url;
		url = urlPrompt();
		if((url == "") || (url == "http://") || (url == null))	return;
		var preText, postText;
		preText = "<a href=\"" + url + "\"" + rightCaret;
		postText = "</a" + rightCaret;
		replaceText (selectionRange, preText, postText, currentText);
		}
	 } /*addLink*/
</script>

<script type="text/javascript">
/* Default format is WYSIWYG HTML*/
var format="HTML";

/* Set the focus to the editor*/
function setFocus()
	{textEdit.focus()}

/* Execute a command against the editor
At minimum one argument is required. Some commands
require a second optional argument:
 eg., ("formatblock","<H1>") to make an H1*/

function execCommand(command)
	{
	textEdit.focus();
	if (format=="HTML")
		{
		var edit = textEdit.document.selection.createRange();
		if (arguments[1]==null) edit.execCommand(command);   
		else
			{
			if(command == "FontSize") addFontSize(arguments[1]);
			else edit.execCommand(command,false, arguments[1]);
			} 
		edit.select();
		textEdit.focus();
		}
	}

/* Selects all the text in the editor*/
function selectAllText()
	{
	var edit = textEdit.document;
	edit.execCommand('SelectAll');
	textEdit.focus();
	}

function newDocument()
	{
	textEdit.document.open();
	textEdit.document.write("");
	textEdit.document.close();
	textEdit.focus();
	}

function loadDoc(htmlString)
	{
	textEdit.document.open();
	textEdit.document.write(htmlString);
	textEdit.document.close();
	}
/* Initialize the editor with an empty document*/

function initEditor()
	{
	var htmlString = parent.document.<cfoutput>#attributes.form_name#.#attributes.field_name#</cfoutput>.value;
	textEdit.document.designMode="On";
	textEdit.document.open();
	textEdit.document.write(htmlString);
	textEdit.document.close();
	textEdit.focus();
	}

/* Swap between WYSIWYG mode and raw HTML mode*/
function swapModes()
	{
	if (format=="HTML")
		{
		textEdit.document.body.innerText = textEdit.document.body.innerHTML;
		textEdit.document.body.style.fontFamily = "monospace";
		textEdit.document.body.style.fontSize = "10pt";
		format="Text"
		}
	else
		{
		textEdit.document.body.innerHTML = textEdit.document.body.innerText;
		textEdit.document.body.style.fontFamily = "";
		textEdit.document.body.style.fontSize ="";
		format="HTML";
		}
	/* textEdit.focus()*/
	var s = textEdit.document.body.createTextRange();
	s.collapse(false);
	s.select();
	}

function InsertFile(serv,gelen,text)
	{
	add_file = "<br/><a href=" + serv + "<cfoutput></cfoutput>"+gelen+" target='_blank'>"+text+"</a>";
	textEdit.document.body.innerHTML += add_file;
	}

function WriteTable(cols,rows,cols_data,rows_data,border)
{
	var pos =0;
	var table_str;
	var separator = ',';
	arrayOfStrings = cols_data.split(separator);
	rowArray = rows_data.split(separator);
	table_str = "<br/><table border=" + border + ">";

	for (i=0;i<rows;i++)
	{
		table_str = table_str + "<tr>";
		for (k=0;k<cols;k++)
		{
			table_str = table_str + "<td>";
			if (i==0)
			{
				if (k !=0 )
				{
					pos = k - 1;
					table_str = table_str + rowArray[pos];
				}
				else
					table_str = table_str + "&nbsp;";
			}
			else if (k == 0)
			{
				pos = i - 1;
				table_str = table_str + arrayOfStrings[pos];
			}
			table_str = table_str + "</td>";
		}
		table_str = table_str + "</tr>";
	}
	table_str = table_str + "</table>";
	textEdit.document.body.innerHTML += table_str;	
}

function WriteFlash(serv,boy,en,dosya)
	{
	add_flash = "<br/><object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" codebase=\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0\" width=\""+boy+"\" height=\""+en+"\" >"+"<param name=\"movie\" value=\"" + serv + "<cfoutput></cfoutput>"+dosya+"\" >"+"<param name=\"quality\" value=\"high\">"+"<embed src=\"" + serv + "<cfoutput></cfoutput>"+dosya+"\""+" quality=\"high\" pluginspage=\"http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash\" type=\"application/x-shockwave-flash\" width=\"195\" height=\"20\">"+"</embed>"+"</object>";
		textEdit.document.body.innerHTML += add_flash;
	}
window.onload = initEditor
</script>
<BODY SCROLL=No><IFRAME ID="textEdit" scrolling="no"></IFRAME><script type="text/javascript">textEdit.focus();</script></body></html>
