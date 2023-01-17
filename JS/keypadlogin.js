var login_keyboardUpperArr = new Array("0","1","2","3","4","5","6","7","8","9","A","B","C","\u00C7","D","E","F","G","\u011E","H","I","\u0130","J","K","L","M","N","O","\u00D6","P","Q","R","S","\u015E","T","U","\u00DC","V","W","X","Y","Z");
var login_keyboardLowerArr = new Array("0","1","2","3","4","5","6","7","8","9","a","b","c","\u00E7","d","e","f","g","\u011F","h","\u0131","i","j","k","l","m","n","o","\u00F6","p","q","r","s","\u015F","t","u","\u00FC","v","w","x","y","z"); 
var login_keyboardQUpperArr = new Array("0","1","2","3","4","5","6","7","8","9","Q","W","E","R","T","Y","U","I","O","P","\u011E","\u00DC","A","S","D","F","G","H","J","K","L","\u015E","\u0130","Z","X","C","V","B","N","M","\u00D6","\u00C7"); 
var login_keyboardQLowerArr = new Array("0","1","2","3","4","5","6","7","8","9","q","w","e","r","t","y","u","\u0131","o","p","\u011F","\u00FC","a","s","d","f","g","h","j","k","l","\u015F","i","z","x","c","v","b","n","m","\u00F6","\u00E7"); 
var login_keyboardArr; 
var login_overlapArr; 
var login_TOTAL_ELEMENT; 
var login_NUMBER_COUNT; 
var login_letterCount; 
var login_currentInput = null; 
var login_keypad = null; 
var login_keypadSize = new Object(); 
login_N = (document.all) ? 0 : 1; 
var login_ob; 
var login_over = false; 
var login_keypadVisible = false; 
var login_writeByMouseOver = false;
var login_timer;
var firsttime = false;

var corrdX,coordY;


function login_populateKeys(){ 
	for (var i = 0; i < login_TOTAL_ELEMENT; i++){ 
		var b = document.getElementsByName("login_b" + i)[0]; 
		b.value = login_keyboardArr[b.getAttribute("login_idx")];
	}
}

function login_changeLetters(){ 
	var t = document.getElementsByName("login_changeOrder")[0]; 
	var b = document.getElementsByName("login_bUpperOrLower")[0]; 
	if(b.value == "K\u00FC\u00E7\u00FCk Harf" || b.value == 'Lower Case') { 
		if(b.value == "K\u00FC\u00E7\u00FCk Harf") { 
			b.value = "B\u00FCy\u00FCk Harf";
		} else{ 
			b.value = "Upper Case"; 
		}
		if(t.value == "Alfabetik" || t.value == "Alphabetical") { 
			login_keyboardArr = login_keyboardQLowerArr;
		} else { 
			login_keyboardArr = login_keyboardLowerArr;
		}
	} else{ 
		if(b.value == "B\u00FCy\u00FCk Harf") { 
			b.value = "K\u00FC\u00E7\u00FCk Harf"; 
		} else{ 
			b.value = "Lower Case"; 
		}
		if(t.value == "Alfabetik" || t.value == "Alphabetical") { 
			login_keyboardArr = login_keyboardQUpperArr;
		} else { 
			login_keyboardArr = login_keyboardUpperArr;
		}
	}
	login_populateKeys();
}

function login_changeType(){ 
	var b = document.getElementsByName("login_changeOrder")[0]; 
	var c = document.getElementsByName("login_bUpperOrLower")[0]; 
	if(b.value == "Q Klavye" || b.value == 'Q Keyboard') { 
		if(b.value == "Q Klavye") {
			b.value = "Alfabetik"; 
		} else {
			b.value = "Alphabetical"; 
		}
		if(c.value == "B\u00FCy\u00FCk Harf" || c.value == 'Upper Case'|| c.value == 'Uppercase') { 
			login_keyboardArr = login_keyboardQLowerArr;
		} else { 
			login_keyboardArr = login_keyboardQUpperArr;
		}
	} else if (b.value == "Alfabetik" || b.value == "Alphabetical") { 
		if (b.value == "Alfabetik"){
			b.value = "Q Klavye"; 
		} else {
			b.value = "Q Keyboard"; 
		}
		if(c.value == "B\u00FCy\u00FCk Harf" || c.value == 'Upper Case'|| c.value == 'Uppercase') { 
			login_keyboardArr = login_keyboardLowerArr;
		} else { 
			login_keyboardArr = login_keyboardUpperArr;
		}
	}

	var e = document.getElementsByName("login_bScrambleOrReset")[0];
	if(e.value == "Harfleri D\u00FCzenle" || e.value == "Alphabetical Order"){ 
		login_scrambleOrReset()
	}
	login_populateKeys();
}

function login_scrambleOrReset(){ 
	var e = document.getElementsByName("login_bScrambleOrReset")[0]; 
	if(e.value == "Harfleri Kar\u0131\u015Ft\u0131r" || e.value == 'Scramble Letters'){ 
		if(e.value == "Harfleri Kar\u0131\u015Ft\u0131r") {
			e.value = "Harfleri D\u00FCzenle"; 
		} else {
			e.value = "Alphabetical Order"; 
		}
		for (var i = login_NUMBER_COUNT; i < login_TOTAL_ELEMENT; i++){ 
			var randomnumber = Math.floor(Math.random()*(login_TOTAL_ELEMENT - 10)) + 10; 
			var b = document.getElementsByName("login_b" + i)[0]; 
			var btemp = document.getElementsByName("login_b" + randomnumber)[0]; 
			var tmpIdx = b.getAttribute("login_idx"); 
			b.setAttribute("login_idx",btemp.getAttribute("login_idx")); 
			btemp.setAttribute("login_idx",tmpIdx);
		}
	} else { 
		if(e.value == "Harfleri D\u00FCzenle") {
			e.value = "Harfleri Kar\u0131\u015Ft\u0131r"; 
		} else {
			e.value = "Scramble Letters"; 
		}
		for (var i = login_NUMBER_COUNT; i < login_TOTAL_ELEMENT; i++){ 
			var b = document.getElementsByName("login_b" + i)[0]; 
			b.setAttribute("login_idx",i);
		}
	}
	login_populateKeys();
}

function login_scrambleNumbers(){ 
	for (var i = 0; i < login_NUMBER_COUNT; i++){ 
		var randomnumber = Math.floor(Math.random() * 10); 
		var b = document.getElementsByName("login_b" + i)[0]; 
		var btemp = document.getElementsByName("login_b" + randomnumber)[0]; 
		var tmpIdx = b.getAttribute("login_idx"); 
		b.setAttribute("login_idx",btemp.getAttribute("login_idx")); 
		btemp.setAttribute("login_idx",tmpIdx);
	}
	login_populateKeys();
}

function login_trim(inputString) { 
	if (typeof inputString != "string") { 
		return inputString;
	}
	var retValue = inputString; 
	var ch = retValue.substring(0, 1); 
	while (ch == " ") { 
		retValue = retValue.substring(1, retValue.length); 
		ch = retValue.substring(0, 1);
	}
	ch = retValue.substring(retValue.length-1, retValue.length); 
	while (ch == " ") { 
		retValue = retValue.substring(0, retValue.length-1); 
		ch = retValue.substring(retValue.length-1, retValue.length);
	}
	while (retValue.indexOf("  ") != -1) { 
		retValue = retValue.substring(0, retValue.indexOf("  ")) + retValue.substring(retValue.indexOf("  ")+1, retValue.length);
	}
	return retValue;
}

function login_clickEvent(keypadChar){
	if(!login_writeByMouseOver) {
		f = login_currentInput;
		if(f.maxLength == null || (f.maxLength != null && f.maxLength == -1) || (f.maxLength != null && f.value.length < f.maxLength)){
			login_insertAtCursor(keypadChar);
		}
	} else {
		return false;
	}
}

function login_mouseOverEvent(keypadChar){
	if(login_writeByMouseOver) {
		f = login_currentInput;
		if(f.maxLength == null || (f.maxLength != null && f.maxLength == -1) || (f.maxLength != null && f.value.length < f.maxLength)){
			login_timer = setTimeout("login_insertAtCursor('"+ keypadChar +"')", 2000);
		}
	} else {
		return false;
	}
}
function login_mouseOutEvent() {
	if(login_writeByMouseOver) {
		clearTimeout(login_timer);
	}
}

function login_insertAtCursor(myValue) {
	var opnr;
	try{
	opnr = window.opener.document.getElementById(login_currentInput.name);
	}catch(err){}
	if (opnr!=null)
		opnr.value = opnr.value + myValue;
	else
		login_currentInput.value = login_currentInput.value + myValue;
	
}

function login_sil(){
	opnr = document.getElementById(login_currentInput.name);
	if (opnr!=null) {
		opnr.value = opnr.value.substring(0,opnr.value.length-1);
	}
	else {
		login_currentInput.value = login_currentInput.value.substring(0,login_currentInput.value.length-1);	
	}
}

function login_showKeypad() { 
	if (document.all) { 
		if(login_keypad.style.visibility != "visible"){ 
			login_keypad.style.visibility="visible";
		}
	} else if (document.layers) { 
		if(login_keypad.visibility != "show"){  
			login_keypad.visibility="show";
		}
	} else { 
		if(login_keypad.style.visibility != "visible"){ 
			login_keypad.style.visibility="visible";
		}
	}
	upper_keypad = document.getElementById("nt_div_keypad"); 
	numpad = document.getElementById("numpd_div_keypad");
	
	document.onmousedown = login_MD; 
	document.onmousemove = login_MM; 
	document.onmouseup = login_MU; 
	
	
	divElement = document.getElementById("div_keypadlogin");
	
	if (login_currentInput.coordX=="-1")
		divElement.style.left=AutoComplete_GetLeft(login_currentInput) + "px";
	else
		divElement.style.left = login_currentInput.coordX + "px";
	
	if (login_currentInput.coordY=="-1")
		divElement.style.top=AutoComplete_GetTop(login_currentInput) + login_currentInput.offsetHeight + "px";
	else
		divElement.style.top = login_currentInput.coordY + "px";

	if (login_currentInput.isKeypad=="true"){
		upper_keypad.style.display = "block";
	}else{
		upper_keypad.style.display = "none";		
	}
	
	if (login_currentInput.isNumpad=="true"){
		numpad.style.display = "block";
	}else{
		numpad.style.display = "none";
	}
	
}

function login_hideKeypad() {
	if (document.all) { 
		login_keypad.style.visibility = "hidden";
	} else if (document.layers) {
		 login_keypad.visibility = "hidden";
	} else { 
		 login_keypad.style.visibility = "hidden";
	}
	
	//benden
	upper_keypad = document.getElementById("nt_div_keypad"); 
	numpad = document.getElementById("numpd_div_keypad");
	
	upper_keypad.style.display = "none";
	numpad.style.display = "none";

}

function login_WinSizeNotSupported() { 
	alert("Browser'\u0131n\u0131z baz\u0131 fonksiyonlar\u0131 desteklemiyor.");
}


function login_initiateKeyboardPos(callCount) { 
	MAX_CALL_COUNT = 10; 
	divElement = document.getElementById("div_keypadlogin");


	for (i=0; i < login_overlapArr.length; i++){ 
		if(login_isOverlap(login_overlapArr[i], divElement) && (callCount < MAX_CALL_COUNT)) { 
			login_initiateKeyboardPos(callCount+1);
		}
	}
}


function login_MD(e) { 
	if(login_keypadVisible) { 
		login_showKeypad();
	} else { 
		login_hideKeypad();
	}
}

function login_MM(e) { 
	if (login_ob) { 
		if (login_N) { 
			login_ob.style.top = e.pageY-Y + 'px'; 
			login_ob.style.left = e.pageX-X + 'px';
		} else { 
			login_ob.pixelLeft = event.clientX-X + document.body.scrollLeft; 
			login_ob.pixelTop = event.clientY-Y + document.body.scrollTop; 
			return false;
		}
	}
}

function login_MU() { 
	login_ob = null;
}


function login_keypadSubmit() { 
	login_hideKeypad(); 
	if(document.forms[0]) {
		if(document.forms[0].onsubmit){ 
			if(document.forms[0].onsubmit()){ 
				document.forms[0].submit();
			}
		} else { 
			document.forms[0].submit();
		}
	}
}

if (login_N) { 
	document.captureEvents(Event.MOUSEDOWN | Event.MOUSEMOVE | Event.MOUSEUP);
}

function login_initializeKeyboard(overlapObj, activationObj){ 

	login_overlapArr = overlapObj; 
	login_NUMBER_COUNT = 10; 
	login_keyboardArr = login_keyboardLowerArr; 
	login_TOTAL_ELEMENT = login_keyboardArr.length; 
	login_letterCount = login_TOTAL_ELEMENT - login_NUMBER_COUNT; 
	login_keypad = document.getElementById("div_keypadlogin"); 
	for (i=0; i < activationObj.length; i++) { 
            activationObj[i].onmouseover = function() {login_keypadVisible=true;}
           	activationObj[i].onmouseout = function() {login_keypadVisible=false;}
            activationObj[i].onfocus = function() {
				login_currentInput = this; 
				login_showKeypad(); 
				if (!firsttime) {
						login_scrambleOrReset(); 
						firsttime = true;
				}
				
				//alert(login_currentInput.isNumpad + "-" + login_currentInput.isKeypad);
			try{				
				if (login_currentInput.isKeypad=="true")
					document.getElementById('numpad_sil').style.display = 'none';
				else
					document.getElementById('numpad_sil').style.display = 'block';
			}catch(err){}
			}
	}
	login_scrambleNumbers();	
}


function login_changeClick() {
	if(document.getElementById("login_chgclick").checked) {
		login_writeByMouseOver = true;
	} else {
		login_writeByMouseOver = false;
	}
}

function pcKlavye(){
	for (var i=0;i<arguments.length;i++){		
		var arr = arguments[i].split(" ");
		var obj = document.getElementById(arr[0]);

		obj.isKeypad = arr[1];
		obj.isNumpad = arr[2];
		
		obj.coordX = arr[3];
		obj.coordY = arr[4];
		
		keypadOverlap= new Array(obj);
		keypadActivation=new Array(obj);
		login_initializeKeyboard(keypadOverlap, keypadActivation);
	}
}

function AutoComplete_GetTop(element)
{
	var curNode = element;
	var top    = 0;
	do
	{
		if(curNode.tagName.toLowerCase() != 'div')//div ise kaymalara sebebe oluyor
			top += curNode.offsetTop;
		curNode = curNode.offsetParent;
	}
	while(curNode.tagName.toLowerCase() != 'body');
	return top;
}

function AutoComplete_GetLeft(element)
{
	var curNode = element;
	var left    = 0;
	do
	{
		if(curNode.tagName.toLowerCase() != 'div')//div ise kaymalara sebebe oluyor
			left += curNode.offsetLeft;
		curNode = curNode.offsetParent;
	}
	while(curNode.tagName.toLowerCase() != 'body');
	return left;
}
