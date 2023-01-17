CKEDITOR.plugins.add( 'charcount',
    {
       init : function(editor)
       {
          var defaultLimit = 'unlimited';
          var defaultFormat = '<span class="cke_charcount_count">%count%</span> of <span class="cke_charcount_limit">%limit%</span> characters';
          var limit = defaultLimit;
          var format = defaultFormat;

          var intervalId;
          var lastCount = 0;
          var limitReachedNotified = false;
          var limitRestoredNotified = false;
         
         /*  var me = this;
           CKEDITOR.dialog.add( 'CharCountDialog', function ()
           {
              return {
                 title : 'Char Count',
                 minWidth : 550,
                 minHeight : 200,
                 contents :
                       [
                          {
                             id : 'iframe',
                             expand : true,
                             elements :[{
                                id : 'embedArea',
                                type : 'textarea',
                                label : 'Embed kodunu giriniz:',
                                'autofocus':'autofocus',
                                setup: function(element){
                                },
                                commit: function(element){
                                }
                              }]
                          }
                       ],
                  onOk : function() {
                    for (var i=0; i<window.frames.length; i++) {
                       if(window.frames[i].name == 'iframeMediaEmbed') {
                          var content = window.frames[i].document.getElementById("embed").value;
                       }
                    }
                    editor.insertHtml(this.getContentElement( 'iframe', 'embedArea' ).getValue());
                 }
              };
           } );
		 */
		 
          if (true)
          {   
			function counterId( editor )
			{
				return 'cke_charcount_' + editor.name;
			}
			
			function counterElement( editor )
			{
				return document.getElementById(counterId(editor));
			}
			
			function getEditorData(editor)
			{
				data = $.trim(editor.getData().replace(/<.*?>/g, '').replace(/\n/g, '').replace(/\r/g, '').replace(/&nbsp;/g, '').replace(/   /g, ''));
				return data;
			}
			
			function updateCounter( editor )
			{
				curData       = getEditorData(editor);
				curDataLength    = curData.length;
            
				count = curDataLength;
				
				
				if( count == lastCount ){
					return true;
				} else {
					lastCount = count;
				}
				if( !limitReachedNotified && count > limit ){
					limitReached( editor );
				} else if( !limitRestoredNotified && count < limit ){
					limitRestored( editor );
				}
				
				var html = format.replace('%count%', count).replace('%limit%', limit);
				counterElement(editor).innerHTML = html;
             }
             
             function limitReached( editor )
             {
				limitReachedNotified = true;
                limitRestoredNotified = false;
                editor.setUiColor( '#FFC4C4' );
            
             }
             
             function limitRestored( editor )
             {
                limitRestoredNotified = true;
                limitReachedNotified = false;
                editor.setUiColor( '#C4C4C4' );
             }

             editor.on( 'themeSpace', function( event )
             {
                if ( event.data.space == 'bottom' )
                {
                   event.data.html += '<div id="'+counterId(event.editor)+'" class="cke_charcount"' +
                      ' title="' + CKEDITOR.tools.htmlEncode( 'Character Counter' ) + '"' +
                      '>&nbsp;</div>';
                }
             }, editor, null, 100 );
             
             editor.on( 'instanceReady', function( event )
             {			

                if( editor.config.charcount_limit != undefined )
                {
                   limit = editor.config.charcount_limit;
                }
               
                if( editor.config.charcount_format != undefined )
                {
                   format = editor.config.charcount_format;
                }
               
               
             }, editor, null, 100 );
             
             editor.on( 'dataReady', function( event )
             {
				var count = $.trim(event.editor.getData().replace(/<.*?>/g, '').replace(/\n/g, '').replace(/\r/g, '').replace(/&nbsp;/g, '').replace(/   /g, '')).length;
                if( count > limit ){
                   limitReached( editor );
                }
                updateCounter(event.editor);
             }, editor, null, 100 );
             
             editor.on( 'key', function( event )
             {
             }, editor, null, 100 );
             
             editor.on( 'focus', function( event )
             {
                editorHasFocus = true;
				intervalId = window.setInterval(function (editor) {   updateCounter(event.editor) }, 1000, event.editor);
				 }, editor, null, 100 );
             
             editor.on( 'blur', function( event )
             {
                editorHasFocus = false;
                if( intervalId )
                   clearInterval(intervalId);
             }, editor, null, 100 );
			 
		/*	 
			 editor.addCommand( 'CharCount', new CKEDITOR.dialogCommand( 'MediaEmbedDialog' ) );
			editor.ui.addButton( 'charcount',
            {
                label: 'char count',
                command: 'CharCount',
                icon: this.path + 'images/icon.png'
            } );*/
          }
       }
    });