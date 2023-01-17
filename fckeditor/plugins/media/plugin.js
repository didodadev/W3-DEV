/**
 * Provides a toolbar button and a dialog to add pasted html code for embed remote media,
 * or uploaded flv choose with file Browser played by  into edited contents.
 *
 * @author Vincent Mazenod   
 * @see doc on http://forge.clermont-universite.fr/wiki/ckmedia 
 * @see Based on http://github.com/n1k0/ckMedia 
 * @see Based on http://github.com/n1k0/ckMediaEmbed
 * @license
 *  
 */
(function() {

  var d = new Date();
  var config = {
    // General
    player: CKEDITOR.basePath + 'plugins/media/mediaplayer-viral/player.swf', 
    replacement: CKEDITOR.basePath + 'plugins/media/images/jwPlayer.gif',
    swfobject: CKEDITOR.basePath + 'plugins/media/mediaplayer-viral/swfobject.js',
    yt: CKEDITOR.basePath + 'plugins/media/mediaplayer-viral/yt.swf',
    player_id:'player_'+d.getTime(),
    div_id:'media_'+d.getTime(),
    version:'9',
    allowfullscreen:'true',
    allowscriptaccess:'always',
    wmode:'opaque',

    plugins: 'gapro-1',
    'gapro.accountid': 'UA-XXXXXXX-X',

    width:'400',
    height:'300',
    
    
    // TAB - single
    file: '',
    image:'',
    author:'100',
    description:'100',
    duration:'100',    
    start:'100',
    title:'100',
    provider:'100',
    //TAB - playlist
    playlistfile:'',
    playlist:'',
    playlistsize:'',
    //TAB - player
    backcolor:'',
    frontcolor:'',
    lightcolor:'',
    screencolor:'',
    controlbar:'',
    dock:'',
    skin:'',
    autostart:'',
    bufferlength:'',
    icons:'',
    item:'',
    mute:'',
    quality:'',
    repeat:'',
    shuffle:'',
    stretching:'',
    volume:'',
    linktarget:'',
    streamer:''
  };
  
  var height = 100;
  
  function refreshConfig(key, value)
  {
    config[key] = value;
  }
  
  function processConfig()
  {

    /*code = "<script type='text/javascript' src='" + config['swfobject'] + "'></script>\n";
    code += "<div id='" + config['div_id'] + "'><img src='" + config['replacement'] + "' width='" + config['width'] + "' height='" + config['height'] + "'/></div>\n";
    code += "<script id='" + config['div_id'] + "_script' type='text/javascript'>\n";
    code += "  var so = new SWFObject('" + config['player'] + "','" + config['player_id'] + "','" + config['width'] + "','" + config['height'] + "','" + config['version'] + "');\n";
    code += "  so.addParam('allowfullscreen','" + config['allowfullscreen'] + "');\n";
    code += "  so.addParam('allowscriptaccess','" + config['allowscriptaccess'] + "');\n";
    code += "  so.addParam('wmode','" + config['wmode'] + "');\n";*/
	
	code =      "<object classid='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000' width='" + config['width'] + "'" + "height='" + config['height'] + "'" + " id='player1' name='player1'>" +
				"<param name='movie' value=" + "'" + config['player'] + "'>" +
			    "<param name='allowfullscreen' value='true'>" +
			    "<param name='allowscriptaccess' value='always'>" +
			    "<param name='flashvars' value='file=" + config['file'] + "&amp;autostart=false'>" +
			    "<embed id='player1'" +
			    "name='player1' " +
			    "src='" + config['player'] + "'" +
			    "width='" + config['width'] + "'" +
			    "height='" + config['height'] + "'" +
			    "allowscriptaccess='always'"+
			    "allowfullscreen='true'"+
			    "flashvars='file=" + config['file'] + "&amp;autostart=false'/></object>"
				 ;
   
    			return code;
  }

  CKEDITOR.plugins.add('Media', {
    init: function (editor) {
      CKEDITOR.dialog.add('MediaDialog', function (editor) {
           return {
          title : 'Flash Video',
          minWidth  : 500,
          minHeight : 100,

          onLoad : function()
          {
            dialog = this;
          },
          contents  : [{
            /**
             *  TAB - code  
             *  simple copy / paste box for embed from youtube, vime, daylymotion etc ... 
             *  Or see Generated code for JW Player  
             */                          
            id : 'code',
            label : 'Embed Kodu',
            expand : true,


            elements : [{
              type :  'textarea',
              id :    'Code_' + editor.name,
              rows : 15
            }]
          },
          {
            /**
             *  TAB - single  
             *  Dialog for JWplayer plays a single FLV
             */
            id : 'single',
            label : 'Flash Video',
            expand : true,
            elements : [{
              // BTN - Browse Media File
              type : 'hbox',
              align : 'center',
              widths : [ '80%', '20%'],
              children :[{
                id : 'MediaFile_' + editor.name,
                type : 'text',
                'default' : config['file'],
                onBlur : function(){
                  refreshConfig('file', this.getDialog().getContentElement('single', 'MediaFile_' + editor.name).getValue());
                  this.getDialog().getContentElement('code', 'Code_' + editor.name).setValue(processConfig());
                },
                label : ' Video Dosyası'
              },
              {
                id : 'BrowseMediaFile_' + editor.name,
                type : 'button',
                hidden : true,                
                filebrowser :
                {
                  action : 'Browse',
				  target: 'info:src0',
				  url: editor.config.filebrowserVideoBrowseUrl || editor.config.filebrowserBrowseUrl,
                  onSelect : function(fileUrl, data)
                  {
                    this.getDialog().getContentElement('single', 'MediaFile_' + editor.name).setValue(fileUrl);
                    refreshConfig('file', this.getDialog().getContentElement('single', 'MediaFile_' + editor.name).getValue());
                    this.getDialog().getContentElement('code', 'Code_' + editor.name).setValue(processConfig());
                  }
                },
                label : 'Sunucuyu Gez',
                style : 'margin-top: 12px; float:right'
              }]
            },
            {
              // BOX - 2 columns
              type : 'hbox',
              align : 'center',
              widths : [ '50%', '50%'],
              children :[{
                type : 'vbox',
                children :[{
                  id:  'MediaWidth_' + editor.name,
                  type: 'text',
                  'default': config['width'],
                  onKeyUp : function(){
                    refreshConfig('width', this.getDialog().getContentElement('single', 'MediaWidth_' + editor.name).getValue());
                    this.getDialog().getContentElement('code', 'Code_' + editor.name).setValue(processConfig());
					
                  },
                  label: 'Genişlik (px)'
                },
                {
                  id:  'MediaHeight_' + editor.name,
                  type: 'text',
                  'default': config['height'],
                  onKeyUp : function(){
                    refreshConfig('height', this.getDialog().getContentElement('single', 'MediaHeight_' + editor.name).getValue());
                    this.getDialog().getContentElement('code', 'Code_' + editor.name).setValue(processConfig());
					
                  },
                  label: 'Yükseklik (px)'
                }]
              }]
            }]
          }],
          onOk : function() {
            editor.insertHtml("<div id='" + config['div_id'] + "_box'>" + dialog.getContentElement('code', 'Code_' + editor.name).getValue() + "</div>");
          }
        };
      });

      editor.addCommand('Media', new CKEDITOR.dialogCommand('MediaDialog'));

      editor.ui.addButton('Media', {
        label:   'Flash Video',
        command: 'Media',
        icon:    this.path + 'images/add.gif'
      });

      if(editor.addMenuItems)
      {
        editor.addMenuItems(  //have to add menu item first
        {
          removeMedia:  //name of the menu item
          {
            label: 'Media',
            command: 'removeMedia',
            icon:    this.path + 'images/remove.gif',
            group: 'removeMedia'  //have to be added in config
          }
        });
      }
      
      editor.addCommand( 'removeMedia', new CKEDITOR.removeMedia() );
      
      if(editor.contextMenu)
      {
        editor.contextMenu.addListener(function(element, selection)  //function to be run when context menu is displayed
        {
            if(! element || !element.is('img') || element.getId() == element.getParent().getId())
              return null;
            
            return { removeMedia: CKEDITOR.TRISTATE_OFF };
        });
      } 
    }
  });
})();

CKEDITOR.removeMedia = function(){};
CKEDITOR.removeMedia.prototype =
{
 	/** @ignore */
	exec : function( editor )
 	{
    editor.getSelection().getSelectedElement().getParent().getParent().remove();
 	}
};
