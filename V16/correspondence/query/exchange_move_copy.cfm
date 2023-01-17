<cfsetting showdebugoutput="no">
<cfparam name="Form.islem" default="">
<cfparam name="Form.folder" default="">
<cfparam name="Form.mail_id" default="">

<!--- Create a connection. --->
<cfinclude template="../display/exchange_conn.cfm">

<style>
body{
font-family:calibri;
font-size:10pt;
}

.dtree {
	font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: #666;
	white-space: nowrap;
	vertical-align:top;
	background-color:white;
	width:300px;
	height:300px;
}
.dtree img {
	border: 0px;
	vertical-align: middle;
}
.dtree a {
	color: #333;
	text-decoration: none;
}
.dtree a.node, .dtree a.nodeSel {
	white-space: nowrap;
	padding: 1px 2px 1px 2px;
}
.dtree a.node:hover, .dtree a.nodeSel:hover {
	color: #333;
	text-decoration: underline;
}
.dtree a.nodeSel {
	background-color: #c0d2ec;
}
.dtree .clip {
	overflow: hidden;
}

input{
width:60px;
font-size:9pt;
}
</style>
<script language="javascript">
	
function Node(id, pid, name, url, title, target, icon, iconOpen, open) {
	this.id = id;
	this.pid = pid;
	this.name = name;
	this.url = url;
	this.title = title;
	this.target = target;
	this.icon = icon;
	this.iconOpen = iconOpen;
	this._io = open || false;
	this._is = false;
	this._ls = false;
	this._hc = false;
	this._ai = 0;
	this._p;
};
// Tree object

function dTree(objName) {

	this.config = {
		target					: null,
		folderLinks			: true,
		useSelection		: true,
		useCookies			: true,
		useLines				: true,
		useIcons				: true,
		useStatusText		: false,
		closeSameLevel	: false,
		inOrder					: false

	}

	this.icon = {
		root				: '/images/exchange/base.gif',
		folder			: '/images/exchange/folder.gif',
		folderOpen	: '/images/exchange/folderopen.gif',
		node				: '/images/exchange/page.gif',
		empty				: '/images/exchange/empty.gif',
		line				: '/images/exchange/line.gif',
		join				: '/images/exchange/join.gif',
		joinBottom	: '/images/exchange/joinbottom.gif',
		plus				: '/images/exchange/plus.gif',
		plusBottom	: '/images/exchange/plusbottom.gif',
		minus				: '/images/exchange/minus.gif',
		minusBottom	: '/images/exchange/minusbottom.gif',
		nlPlus			: '/images/exchange/nolines_plus.gif',
		nlMinus			: '/images/exchange/nolines_minus.gif'

	};

	this.obj = objName;
	this.aNodes = [];
	this.aIndent = [];
	this.root = new Node(-1);
	this.selectedNode = null;
	this.selectedFound = false;
	this.completed = false;
};
// Adds a new node to the node array

dTree.prototype.add = function(id, pid, name, url, title, target, icon, iconOpen, open) {
	this.aNodes[this.aNodes.length] = new Node(id, pid, name, url, title, target, icon, iconOpen, open);

};
// Open/close all nodes

dTree.prototype.openAll = function() {
	this.oAll(true);
};

dTree.prototype.closeAll = function() {
	this.oAll(false);
};

//Outputs the tree to the page

dTree.prototype.toString = function() {

	var str = '<div class="dtree">\n';
	if (document.getElementById) {
		if (this.config.useCookies) this.selectedNode = this.getSelected();
		str += this.addNode(this.root);
	} else str += 'Browser not supported.';
	str += '</div>';
	if (!this.selectedFound) this.selectedNode = null;
	this.completed = true;
	return str;
};
// Creates the tree structure

dTree.prototype.addNode = function(pNode) {

	var str = '';
	var n=0;
	if (this.config.inOrder) n = pNode._ai;
	for (n; n<this.aNodes.length; n++) {
		if (this.aNodes[n].pid == pNode.id) {
			var cn = this.aNodes[n];
			cn._p = pNode;
			cn._ai = n;
			this.setCS(cn);
			if (!cn.target && this.config.target) cn.target = this.config.target;
			if (cn._hc && !cn._io && this.config.useCookies) cn._io = this.isOpen(cn.id);
			if (!this.config.folderLinks && cn._hc) cn.url = null;
			if (this.config.useSelection && cn.id == this.selectedNode && !this.selectedFound) {
					cn._is = true;
					this.selectedNode = n;
					this.selectedFound = true;
			}

			str += this.node(cn, n);
			if (cn._ls) break;
		}
	}
	return str;
};
// Creates the node icon, url and text

dTree.prototype.node = function(node, nodeId) {

	var str = '<div class="dTreeNode">' + this.indent(node, nodeId);
	if (this.config.useIcons) {
		if (!node.icon) node.icon = (this.root.id == node.pid) ? this.icon.root : ((node._hc) ? this.icon.folder : this.icon.node);
		if (!node.iconOpen) node.iconOpen = (node._hc) ? this.icon.folderOpen : this.icon.node;
		if (this.root.id == node.pid) {
			node.icon = this.icon.root;
			node.iconOpen = this.icon.root;
		}
		str += '<img id="i' + this.obj + nodeId + '" src="' + ((node._io) ? node.iconOpen : node.icon) + '" alt="" />';
	}

	if (node.url) {
		str += '<a id="s' + this.obj + nodeId + '" class="' + ((this.config.useSelection) ? ((node._is ? 'nodeSel' : 'node')) : 'node') + '" href="#" onclick="setFolder(\'' + node.url + '\',this)"';
		if (node.title) str += ' title="' + node.title + '"';
		if (node.target) str += '';
		if (this.config.useStatusText) str += ' onmouseover="window.status=\'' + node.name + '\';return true;" onmouseout="window.status=\'\';return true;" ';
		if (this.config.useSelection && ((node._hc && this.config.folderLinks) || !node._hc))
			str += ' onclick="javascript: ' + this.obj + '.s(' + nodeId + ');"';

		str += '>';
	}
	else if ((!this.config.folderLinks || !node.url) && node._hc && node.pid != this.root.id)
		str += '<a href="javascript: ' + this.obj + '.o(' + nodeId + ');" class="node">';

	str += node.name;
	if (node.url || ((!this.config.folderLinks || !node.url) && node._hc)) str += '</a>';
	str += '</div>';

	if (node._hc) {
		str += '<div id="d' + this.obj + nodeId + '" class="clip" style="display:' + ((this.root.id == node.pid || node._io) ? 'block' : 'none') + ';">';
		str += this.addNode(node);
		str += '</div>';
	}

	this.aIndent.pop();
	return str;
};

// Adds the empty and line icons
dTree.prototype.indent = function(node, nodeId) {
	var str = '';
	if (this.root.id != node.pid) {
		for (var n=0; n<this.aIndent.length; n++)
			str += '<img src="' + ( (this.aIndent[n] == 1 && this.config.useLines) ? this.icon.line : this.icon.empty ) + '" alt="" />';
		(node._ls) ? this.aIndent.push(0) : this.aIndent.push(1);
		if (node._hc) {
			str += '<a href="javascript: ' + this.obj + '.o(' + nodeId + ');"><img id="j' + this.obj + nodeId + '" src="';
			if (!this.config.useLines) str += (node._io) ? this.icon.nlMinus : this.icon.nlPlus;
			else str += ( (node._io) ? ((node._ls && this.config.useLines) ? this.icon.minusBottom : this.icon.minus) : ((node._ls && this.config.useLines) ? this.icon.plusBottom : this.icon.plus ) );
			str += '" alt="" /></a>';

		} else str += '<img src="' + ( (this.config.useLines) ? ((node._ls) ? this.icon.joinBottom : this.icon.join ) : this.icon.empty) + '" alt="" />';
	}
	return str;
};
// Checks if a node has any children and if it is the last sibling

dTree.prototype.setCS = function(node) {
	var lastId;
	for (var n=0; n<this.aNodes.length; n++) {
		if (this.aNodes[n].pid == node.id) node._hc = true;
		if (this.aNodes[n].pid == node.pid) lastId = this.aNodes[n].id;
	}
	if (lastId==node.id) node._ls = true;
};
// Returns the selected node

dTree.prototype.getSelected = function() {
	var sn = this.getCookie('cs' + this.obj);
	return (sn) ? sn : null;
};

// Highlights the selected node

dTree.prototype.s = function(id) {
	if (!this.config.useSelection) return;
	var cn = this.aNodes[id];
		if (cn._hc && !this.config.folderLinks) return;
	if (this.selectedNode != id) {
		if (this.selectedNode || this.selectedNode==0) {
			eOld = document.getElementById("s" + this.obj + this.selectedNode);
			eOld.className = "node";
		}

		eNew = document.getElementById("s" + this.obj + id);
		eNew.className = "nodeSel";
		this.selectedNode = id;
		if (this.config.useCookies) this.setCookie('cs' + this.obj, cn.id);
	}

};
// Toggle Open or close

dTree.prototype.o = function(id) {
	var cn = this.aNodes[id];
	this.nodeStatus(!cn._io, id, cn._ls);
	cn._io = !cn._io;
	if (this.config.closeSameLevel) this.closeLevel(cn);
	if (this.config.useCookies) this.updateCookie();
};
// Open or close all nodes
dTree.prototype.oAll = function(status) {
	for (var n=0; n<this.aNodes.length; n++) {
		if (this.aNodes[n]._hc && this.aNodes[n].pid != this.root.id) {
			this.nodeStatus(status, n, this.aNodes[n]._ls)
			this.aNodes[n]._io = status;
		}
	}
	if (this.config.useCookies) this.updateCookie();
};
// Opens the tree to a specific node

dTree.prototype.openTo = function(nId, bSelect, bFirst) {
	if (!bFirst) {
		for (var n=0; n<this.aNodes.length; n++) {
			if (this.aNodes[n].id == nId) {
				nId=n;
				break;
			}
		}
	}

	var cn=this.aNodes[nId];
	if (cn.pid==this.root.id || !cn._p) return;
	cn._io = true;
	cn._is = bSelect;
	if (this.completed && cn._hc) this.nodeStatus(true, cn._ai, cn._ls);
	if (this.completed && bSelect) this.s(cn._ai);
	else if (bSelect) this._sn=cn._ai;
	this.openTo(cn._p._ai, false, true);

};
// Closes all nodes on the same level as certain node

dTree.prototype.closeLevel = function(node) {
	for (var n=0; n<this.aNodes.length; n++) {
		if (this.aNodes[n].pid == node.pid && this.aNodes[n].id != node.id && this.aNodes[n]._hc) {
			this.nodeStatus(false, n, this.aNodes[n]._ls);
			this.aNodes[n]._io = false;
			this.closeAllChildren(this.aNodes[n]);
		}
	}
}
// Closes all children of a node

dTree.prototype.closeAllChildren = function(node) {
	for (var n=0; n<this.aNodes.length; n++) {
		if (this.aNodes[n].pid == node.id && this.aNodes[n]._hc) {
			if (this.aNodes[n]._io) this.nodeStatus(false, n, this.aNodes[n]._ls);
			this.aNodes[n]._io = false;
			this.closeAllChildren(this.aNodes[n]);		
		}
	}
}
// Change the status of a node(open or closed)

dTree.prototype.nodeStatus = function(status, id, bottom) {
	eDiv	= document.getElementById('d' + this.obj + id);
	eJoin	= document.getElementById('j' + this.obj + id);
	if (this.config.useIcons) {
		eIcon	= document.getElementById('i' + this.obj + id);
		eIcon.src = (status) ? this.aNodes[id].iconOpen : this.aNodes[id].icon;
	}
	
	eJoin.src = (this.config.useLines)?
	((status)?((bottom)?this.icon.minusBottom:this.icon.minus):((bottom)?this.icon.plusBottom:this.icon.plus)):
	((status)?this.icon.nlMinus:this.icon.nlPlus);
	eDiv.style.display = (status) ? 'block': 'none';
};

// [Cookie] Clears a cookie

dTree.prototype.clearCookie = function() {
	var now = new Date();
	var yesterday = new Date(now.getTime() - 1000 * 60 * 60 * 24);
	this.setCookie('co'+this.obj, 'cookieValue', yesterday);
	this.setCookie('cs'+this.obj, 'cookieValue', yesterday);
};

// [Cookie] Sets value in a cookie

dTree.prototype.setCookie = function(cookieName, cookieValue, expires, path, domain, secure) {
	document.cookie =
		escape(cookieName) + '=' + escape(cookieValue)
		+ (expires ? '; expires=' + expires.toGMTString() : '')
		+ (path ? '; path=' + path : '')
		+ (domain ? '; domain=' + domain : '')
		+ (secure ? '; secure' : '');
};

// [Cookie] Gets a value from a cookie

dTree.prototype.getCookie = function(cookieName) {
	var cookieValue = '';
	var posName = document.cookie.indexOf(escape(cookieName) + '=');
	if (posName != -1) {
		var posValue = posName + (escape(cookieName) + '=').length;
		var endPos = document.cookie.indexOf(';', posValue);
		if (endPos != -1) cookieValue = unescape(document.cookie.substring(posValue, endPos));
		else cookieValue = unescape(document.cookie.substring(posValue));
	}
	return (cookieValue);
};

// [Cookie] Returns ids of open nodes as a string

dTree.prototype.updateCookie = function() {
	var str = '';
	for (var n=0; n<this.aNodes.length; n++) {
		if (this.aNodes[n]._io && this.aNodes[n].pid != this.root.id) {
			if (str) str += '.';
			str += this.aNodes[n].id;
		}
	}

	this.setCookie('co' + this.obj, str);
};
// [Cookie] Checks if a node id is in a cookie

dTree.prototype.isOpen = function(id) {
	var aOpen = this.getCookie('co' + this.obj).split('.');
	for (var n=0; n<aOpen.length; n++)
		if (aOpen[n] == id) return true;
	return false;
};
// If Push and pop is not implemented by the browser

if (!Array.prototype.push) {
	Array.prototype.push = function array_push() {
		for(var i=0;i<arguments.length;i++)
			this[this.length]=arguments[i];
		return this.length;
	}
};

if (!Array.prototype.pop) {
	Array.prototype.pop = function array_pop() {
		lastElement = this[this.length-1];
		this.length = Math.max(this.length-1,0);
		return lastElement;
	}
};	

var preObj = null;
function setFolder(folderName,obj){
	document.getElementById('selectedFolder').value=folderName;
	
	obj.style.backgroundColor='#316ac5';
	obj.style.color = 'white';
	if (preObj != null){
		preObj.style.backgroundColor='';
		preObj.style.color = 'black';
	}
		
	preObj = obj;
}

function cancel(){
	window.opener.focus();
	window.close();
}

function moveFolder(){
	var selectedFolder = document.getElementById('selectedFolder').value;
	var reachedFolder = document.getElementById('reachedFolder').value;
	if (selectedFolder=="")	{alert('Bir klasör seçmelisiniz...');return false;}
	if (selectedFolder==reachedFolder){alert('Mailiniz şu anda bu klasörde, başka bir klasör seçiniz...');return false;}
	
	document.forms['folders_form'].submit();
}

</script>

<body bgcolor="#c3daf9">
<cfoutput>
	<form action="http://<cfoutput>#cgi.HTTP_HOST#</cfoutput>/index.cfm?fuseaction=correspondence.emptypopup_exchange_islem" method="post" id="folders_form" style="display:none">
	  <strong>
		<input type="text" name="islem" id="islem" value="move" />
		<input type="text" name="mail_id" id="mail_id" value="#FORM.mail_id#" style="width:100%" />
		<input type="text" name="folder" id="reachedFolder" value="#Form.folder#" />
		<input type="text" name="destinationFolder" id="selectedFolder" />
	  </strong>
	</form>
</cfoutput>

<strong>
<cfset excludingFolderList = "Gelen Kutusu,Giden Kutusu,Gönderilmiş Öğeler,Önemsiz Elektronik Posta,Görevler,Günlük,İlgili Kişiler,Notlar,Takvim,Silinmiş Öğeler,Taslaklar">
<cfset i = 5>
Secili öğeleri klasöre taşı/kopyala
<script language="javascript">
	</script>
</strong>
<script language="javascript"><cfoutput>
	d = new dTree('d');
	d.add(0,-1,'Serhat Gökmen','','','/images/exchange/personalfolders.gif','/images/exchange/personalfolders.gif');
	
	d.add(1,0,'Gelen Kutusu','Gelen Kutusu','','','/images/exchange/inbox.gif','/images/exchange/inbox.gif');#getFolder("Gelen Kutusu","1")#
	
	d.add(2,0,'Giden Kutusu','Giden Kutusu','','','/images/exchange/SentItems.gif','/images/exchange/SentItems.gif');#getFolder("Giden Kutusu","2")#
	
	d.add(3,0,'Gönderilmiş Öğeler','Gönderilmiş Öğeler','','','/images/exchange/sent.gif','/images/exchange/sent.gif');#getFolder("Gönderilmiş Öğeler","3")#
		
	d.add(4,0,'Önemsiz Elektronik Posta','Önemsiz Elektronik Posta','','','/images/exchange/junk.gif','/images/exchange/junk.gif');#getFolder("Önemsiz Elektronik Posta","4")#

	#getAllFolder()#
		
	d.add(#i#,0,'Silinmiş Öğeler','Silinmiş Öğeler','','','/images/exchange/DeletedItems.gif','/images/exchange/DeletedItems.gif');#getFolder("Silinmiş Öğeler","#i++#")#
	
	d.add(#i#,0,'Taslaklar','Taslaklar','','','','/images/exchange/drafts.gif','/images/exchange/drafts.gif');#getFolder("Taslaklar","#i++#")#
	</cfoutput>
		
	document.write(d);

</script>

<table width="300">
	<tr>
	  <td width="85"><input type="submit" name="new" value="Yeni" disabled="disabled" /></td>
	  <td width="65"><input type="submit" name="move" value="Taşı" onClick="moveFolder()" /></td>
	  <td width="65"><input type="button" name="copy" value="Kopyala"  disabled="disabled"/></td>
	  <td width="65"><input type="submit" name="cancel" value="İptal" onClick="cancel()" /></td>
	</tr>
</table>
</body>
<cfexchangeConnection action="close" connection="sample">


<!--- FUNCTIONS --->
<cffunction name="getAllFolder">
  <cfargument type="string" name="folder" default="" required="no">
  <cfargument type="numeric" name="index" default=0 required="no">
  <cfexchangeconnection action="getSubfolders" connection="sample" folder="#folder#" name="folderInfo" recurse="no">
  <cfloop query="folderInfo">
    <cfif ListFindNoCase(excludingFolderList,foldername,",") eq FALSE>
      <cfset i++>
	  	  
	  <cfoutput>
        d.add(#i#,#index#,'#foldername#','#folderpath#','','','/images/exchange/folder.gif','/images/exchange/folder.gif');
		#getAllFolder("#folderpath#","#i#")#
      </cfoutput>
    </cfif>
  </cfloop>
</cffunction>

<cffunction name="getFolder">
  <cfargument type="string" name="folder" default="" required="no">
  <cfargument type="numeric" name="index" default=0 required="no">
  <cfexchangeconnection action="getSubfolders" connection="sample" folder="#folder#" name="folderInfo" recurse="no">
  <cfloop query="folderInfo">
      <cfset i++>
  	  
	  <cfoutput>
        d.add(#i#,#index#,'#foldername#','#folderpath#','','','/images/exchange/folder.gif','/images/exchange/folder.gif');
		#getFolder("#folderpath#","#i#")#
      </cfoutput>
  </cfloop>
</cffunction>

