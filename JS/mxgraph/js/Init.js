// urlParams is null when used for embedding
window.urlParams = window.urlParams || {};

// Public global variables
window.MAX_REQUEST_SIZE = window.MAX_REQUEST_SIZE  || 10485760;
window.MAX_AREA = window.MAX_AREA || 15000 * 15000;

var process_url = document.URL;
var url_split = process_url.split('&');
var url_type = url_split[1];
var process_id = url_split[2];
if(url_split[3]){
    var action_section = '&'+url_split[3];
}else{
    var action_section = '';
}
if(url_split[4]){
    var relative_id = '&'+url_split[4];
}else{
    var relative_id = '';
}

// URLs for save and export
window.EXPORT_URL = window.EXPORT_URL || 'index.cfm?fuseaction=process.emptypopup_visual_designer&'+url_type+'&'+process_id+action_section+relative_id;
window.SAVE_URL = window.SAVE_URL || 'index.cfm?fuseaction=process.emptypopup_visual_designer&'+url_type+'&'+process_id+action_section+relative_id;
window.OPEN_URL = window.OPEN_URL || '/open';
window.RESOURCES_PATH = window.RESOURCES_PATH || '/JS/mxgraph/resources';
window.RESOURCE_BASE = window.RESOURCE_BASE || window.RESOURCES_PATH + '/grapheditor';
window.STENCIL_PATH = window.STENCIL_PATH || '/JS/mxgraph/stencils';
window.IMAGE_PATH = window.IMAGE_PATH || '/JS/mxgraph/images';
window.STYLE_PATH = window.STYLE_PATH || '/JS/mxgraph/styles';
window.CSS_PATH = window.CSS_PATH || '/JS/mxgraph/styles';
window.OPEN_FORM = window.OPEN_FORM || '/JS/mxgraph/open.html';

// Sets the base path, the UI language via URL param and configures the
// supported languages to avoid 404s. The loading of all core language
// resources is disabled as all required resources are in grapheditor.
// properties. Note that in this example the loading of two resource
// files (the special bundle and the default bundle) is disabled to
// save a GET request. This requires that all resources be present in
// each properties file since only one file is loaded.
window.mxBasePath = window.mxBasePath || '/JS/mxgraph/src';
window.mxLanguage = window.mxLanguage || urlParams['lang'];
window.mxLanguages = window.mxLanguages || ['de'];