/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */
CKEDITOR.dtd.$removeEmpty['span'] = false;
CKEDITOR.editorConfig = function( config ) {
	
	// Define changes to default configuration here.
	// For complete reference see:
	// http://docs.ckeditor.com/#!/api/CKEDITOR.config

	// The toolbar groups arrangement, optimized for two toolbar rows.
	config.skin = 'office2013';
	config.image_previewText = CKEDITOR.tools.repeat( ' ', 1 );
	config.entities_latin=0;
	config.entities = false;
	config.FormatSource	= false ;
	config.FormatOutput	= false ;
	config.replaceByClassEnabled = false;
	config.disableAutoInline = true;
	config.filebrowserBrowseUrl = 'index.cfm?fuseaction=objects.emptypopup_ckfinder';
	config.filebrowserImageBrowseUrl = 'index.cfm?fuseaction=objects.emptypopup_ckfinder&Type=Images';
	config.filebrowserFlashBrowseUrl = 'index.cfm?fuseaction=objects.emptypopup_ckfinder&Type=Flash';
	config.filebrowserUploadUrl =	   '/fckeditor/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Belgeler';
	config.filebrowserImageUploadUrl = '/fckeditor/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Images';
	config.filebrowserFlashUploadUrl = '/fckeditor/ckfinder/core/connector/cfm/connector.cfm?command=QuickUpload&type=Flash';
	config.filebrowserVideoBrowseUrl = '/fckeditor/ckfinder/ckfinder.html?Type=Media';
	config.enterMode = CKEDITOR.ENTER_P;
	config.shiftEnterMode = CKEDITOR.ENTER_BR;

	config.extraPlugins = 'font,colorbutton,panelbutton';
	
	config.toolbarGroups = [
		{ name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
		{ name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
		{ name: 'links' },
		{ name: 'insert', groups : [ 'Image','Video','Flash','Media','-','Table','HorizontalRule','Smiley','SpecialChar','PageBreak','Iframe' ] },
		{ name: 'forms' },
		{ name: 'tools' },
		{ name: 'document',	   groups: [ 'mode', 'document', 'doctools','Preview' ] },
		{ name: 'others' },
		'/',
		{ name: 'basicstyles', groups: [ 'Font','FontSize','Bold','Italic','Underline','Strike','Subscript','Superscript'] },
		{ name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ] },
		{ name: 'styles' },
		{ name: 'colors', groups: [ 'TextColor', 'BGColor' ] },
	];
};
