<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=5,IE=9" ><![endif]-->
<head>
    <title>Grapheditor</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
	<link rel="stylesheet" type="text/css" href="/JS/mxgraph/styles/grapheditor.css?version=2">
	<style>
		#xmlSettings {
			display : none;
		}
	</style>
	<script type="text/javascript">
		// Parses URL parameters. Supported parameters are:
		// - lang=xy: Specifies the language of the user interface.
		// - touch=1: Enables a touch-style user interface.
		// - storage=local: Enables HTML5 local storage.
		// - chrome=0: Chromeless mode.
		var urlParams = (function(url)
		{
			var result = new Object();
			var idx = url.lastIndexOf('?');
	
			if (idx > 0)
			{
				var params = url.substring(idx + 1).split('&');
				
				for (var i = 0; i < params.length; i++)
				{
					idx = params[i].indexOf('=');
					
					if (idx > 0)
					{
						result[params[i].substring(0, idx)] = params[i].substring(idx + 1);
					}
				}
			}
			
			return result;
		})(window.location.href);
	
		// Default resources are included in grapheditor resources
		mxLoadResources = false;
	</script>
	<script type="text/javascript" src="/JS/mxgraph/js/Init.js?version=5"></script>
	<script type="text/javascript" src="/JS/mxgraph/deflate/pako.min.js"></script>
	<script type="text/javascript" src="/JS/mxgraph/deflate/base64.js"></script>
	<script type="text/javascript" src="/JS/mxgraph/jscolor/jscolor.js"></script>
	<script type="text/javascript" src="/JS/mxgraph/sanitizer/sanitizer.min.js"></script>
	<script type="text/javascript" src="/JS/mxgraph/src/js/mxClient.js"></script>
	<script type="text/javascript" src="/JS/mxgraph/js/EditorUi.js?version=5"></script>
	<script type="text/javascript" src="/JS/mxgraph/js/Editor.js"></script>
	<script type="text/javascript" src="/JS/mxgraph/js/Sidebar.js?version=4"></script>
	<script type="text/javascript" src="/JS/mxgraph/js/Graph.js"></script>
	<script type="text/javascript" src="/JS/mxgraph/js/Format.js"></script>
	<script type="text/javascript" src="/JS/mxgraph/js/Shapes.js"></script>
	<script type="text/javascript" src="/JS/mxgraph/js/Actions.js"></script>
	<script type="text/javascript" src="/JS/mxgraph/js/Menus.js"></script>
	<script type="text/javascript" src="/JS/mxgraph/js/Toolbar.js"></script>
	<script type="text/javascript" src="/JS/mxgraph/js/Dialogs.js"></script>
</head>
<div class="geEditor">
	<script type="text/javascript">
		// Extends EditorUi to update I/O action states based on availability of backend
		<cfif isdefined('attributes.event') and len(attributes.event) and attributes.event neq 'concept'>
			alert("<cf_get_lang dictionary_id ='57482.Aşama'>: <cf_get_lang dictionary_id ='52944.development'> ");
		</cfif>
		(function()
		{
			var editorUiInit = EditorUi.prototype.init;
			<cfif isdefined('attributes.id') and len(attributes.id)>
				<cfset getComponent = createObject('component','V16.process.cfc.get_design')>
				<cfset get_xml = getComponent.GET_XML(id : attributes.id)>
				Editor.prototype.filename = '<cfoutput>#get_xml.FILE_NAME#</cfoutput>';
				EditorUi.prototype.init = function()
				{
					
					editorUiInit.apply(this, arguments);
					this.actions.get('export').setEnabled(false);
					/*// Updates action states which require a backend
					if (!Editor.useLocalStorage)
					{
						mxUtils.post(OPEN_URL, '', mxUtils.bind(this, function(req)
						{
							var enabled = req.getStatus() != 404;
							this.actions.get('open').setEnabled(enabled || Graph.fileSupport);
							this.actions.get('import').setEnabled(enabled || Graph.fileSupport);
							this.actions.get('save').setEnabled(enabled);
							this.actions.get('saveAs').setEnabled(enabled);
							this.actions.get('export').setEnabled(enabled);
						}));
					}*/
					this.actions.get("import").funct();
					window.openFile.setData('<cfoutput>#replace(get_xml.xml,"'","","all")#</cfoutput>', '<cfoutput>#get_xml.file_name#</cfoutput>');//id gelince kontrolü yapılacak.
				};	
			</cfif>
			
			// Adds required resources (disables loading of fallback properties, this can only
			// be used if we know that all keys are defined in the language specific file)
			//mxResources.loadDefaultBundle = false;
			var bundle = mxResources.getDefaultBundle(RESOURCE_BASE, mxLanguage) ||
				mxResources.getSpecialBundle(RESOURCE_BASE, mxLanguage);  // bundle = JS/mxgraph/resources/grapheditor.txt

			//genel toolbardaki temalar şekil ve renkleri xml dosyasından alıyor.
			mxUtils.getAll([bundle, STYLE_PATH + '/default.xml'], function(xhr)
			{
				// Adds bundle text to resources
				mxResources.parse(xhr[0].getText());
				
				// Configures the default graph theme
				var themes = new Object();
				themes[Graph.prototype.defaultThemeName] = xhr[1].getDocumentElement(); 
				
				// Main
				new EditorUi(new Editor(urlParams['chrome'] == '0', themes));
			}, function()
			{
				document.body.innerHTML = '<center >Error loading resource files. Please check browser console.</center>';
			});
		})();
	</script>
</div>