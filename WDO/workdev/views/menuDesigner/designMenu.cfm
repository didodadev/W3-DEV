<div class="bootstrap-catalyst" id="design-app">    
    <div class="page-wrapper chiller-theme toggled">
    <a id="show-sidebar" class="btn btn-sm btn-dark">
        <i class="fas fa-cubes"></i>
    </a>
    <nav id="sidebar" class="sidebar-wrapper">
        <div class="sidebar-content">
        <div class="sidebar-brand">
            <a>Menu Tools</a>
        </div>
        <div class="sidebar-menu">
            <ul>
            <li class="header-menu">
                <span><i class="fas fa-link"></i> Available Links</span>
            </li>
            <li class="sidebar-dropdown" v-for="item in solutions">
                <a @click="getFamily(item[0])">
                <i class="fas fa-cube"></i>
                <span>{{ item[1] }}</span>
                </a>
                <div class="sidebar-submenu">
                    <ul>
                        <li v-for="item in familys">
                            <a @click="getModule(item[0])">{{ item[1] }}</a> 
                            <div class="sidebar-submenu">
                                <ul>
                                    <li v-for="item in modules">
                                        <a @click="getObject(item[0])">{{ item[1] }}</a> 
                                        <div class="sidebar-submenu">
                                            <ul>
                                                <li v-for="item in objects">
                                                    <a @click="addSwapBasket(item[0],item[1],item[4],item[2],'','',item[5])">{{ item[1] }}</a>                        
                                                </li>
                                            </ul>
                                        </div>                        
                                    </li>
                                </ul>
                            </div>                       
                        </li>
                    </ul>
                </div>
            </li>
            </ul>
        </div>
        <!-- sidebar-menu  -->
        </div>
    </nav>
    <!-- sidebar-wrapper  -->
    <cf_catalystHeader>
    <main class="page-content">
        <!--- <nav class="navbar navbar-expand-lg navbar-light bg-white nav-sa">
            <a class="navbar-brand">W3 MenuDesigner</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto font-weight-bold ">
                    <li class="nav-item">
                        <a class="nav-link"><i class="fas fa-question"></i> Help</a>
                    </li>
                    <li class="nav-item" @click="saveModal" >
                        <a class="nav-link text-success" v-if="xevent=='add'"><i class="fas fa-rocket"></i> Save</a>
                        <a class="nav-link text-warning" v-else><i class="fas fa-rocket"></i> Update</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#md&event=list"><i class="fas fa-list-ul"></i> Menu List</a>
                    </li>                      
                </ul>
            </div>
        </nav>
        <nav aria-label="breadcrumb" class="wmdBreadCrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="#md&event=list">W3 MenuDesigner</a></li>
                <li class="breadcrumb-item"><a href="#md&event=list">List</a></li>
                <li class="breadcrumb-item active" aria-current="page"  v-if="xevent=='add'">Add New Menu</li>
                <li class="breadcrumb-item active" aria-current="page"  v-else>Update Menu : {{saveMenuForm[0].name}}</li>
            </ol>
        </nav>        --->
        <div class="container-fluid">       
            <div class="rw m-0">
            <div class="cl-12 p-0" id="alertMessage"></div>
            </div>
            <div class="rw">       
                <div class="cl-12 cl-md-5">
                    <div class="card border-danger">
                        <div class="card-header text-danger font-weight-bold">
                        Basket
                        <i class="fas fa-folder-plus float-right text-muted ml-2" data-toggle="modal" data-target="#addGroupModal" style=" font-size: 18px; "></i>
                        <i class="fas fa-link float-right text-muted ml-2" data-toggle="modal" data-target="#addLinkModal" style=" font-size: 18px; "></i>
                        </div>
                        <div class="card-body pt-0">
                        <div class="dd" id="swap-basket">
                            <ol class="dd-list">
                                <li class="dd-item dd-nochildren dd-nodrag" data-id="0" style=" line-height: 0; min-height: 1px;"></li>
                                <li class="dd-item" 
                                v-bind:class="{'dd-nochildren type-child' : item.type=='child' || item.type=='link', 'type-group' : item.type != 'child' && item.type != 'link'}" 
                                v-for="item in basket" 
                                v-bind:data-id="item.id"
                                v-bind:data-type="item.type" 
                                v-bind:data-desc="item.description" 
                                v-bind:data-name="item.name"
                                v-bind:data-dictionary="item.dictionary_id"
                                v-bind:data-ico="item.icon"
                                v-bind:data-style="item.style"
                                v-bind:data-url="item.url">
                                    <div v-if="item.type=='child' || item.type=='link'" class="dd-handle">
                                        <div class="item_title">{{item.name}}</div>                             
                                    </div>
                                    <div v-else class="dd-handle">
                                        <div class="item_title">{{item.name}}</div> 
                                    </div>
                                    <div class="item_tools">
                                        <i class="fas fa-trash-alt delete_item" @click="deleteItem()"></i>
                                        <i class="fas fa-edit edit_item" v-if="item.type=='child' || item.type=='link'" @click="editLink()"></i>                                  
                                        <i class="fas fa-edit edit_item" v-else @click="editGroup()" ></i>                                  
                                    </div>
                                </li>
                            </ol>
                        </div>
                        </div>
                        <div class="card-footer text-muted">
                        *Create menu on the right with the elements in the basket
                        </div>
                    </div>                    
                </div>
                <div class="cl-12 cl-md-5">
                    <div class="card border-info">
                    <div class="card-header text-info font-weight-bold">
                        Menu
                    </div>
                    <div class="card-body pt-0">
                        <div class="dd" id="menu-basket">
                            <ol class="dd-list">
                                <li v-for="item in updateJson"
                                    class="dd-item" 
                                    v-bind:class="{'dd-nochildren type-child' : item.type=='child' || item.type=='link', 'type-group' : item.type != 'child' && item.type != 'link'}"
                                    v-bind:data-id="item.id" 
                                    v-bind:data-type="item.type" 
                                    v-bind:data-desc="item.desc" 
                                    v-bind:data-name="item.name" 
                                    v-bind:data-dictionary="item.dictionary" 
                                    v-bind:data-ico="item.ico" 
                                    v-bind:data-style="item.style"
                                    v-bind:data-url="item.url" 
                                    >
                                    <button class="dd-collapse" data-action="collapse" type="button" v-if="item.type != 'child' && item.type != 'link'">Collapse</button>
                                    <button class="dd-expand" data-action="expand" type="button" v-if="item.type != 'child' && item.type != 'link'">Expand</button>
                                    <div class="dd-handle">
                                        <div class="item_title">{{item.name}}</div>
                                    </div> 
                                    <div class="item_tools">
                                        <i class="fas fa-trash-alt delete_item" @click="deleteItem()"></i>
                                        <i class="fas fa-edit edit_item" v-if="item.type=='child' || item.type=='link'" @click="editLink()"></i>                                  
                                        <i class="fas fa-edit edit_item" v-else @click="editGroup()" ></i>    
                                    </div>
                                    <ol class="dd-list" v-if="item.children"><!--- Depth 1 --->
                                        <li v-for="item in item.children"
                                            class="dd-item" 
                                            v-bind:class="{'dd-nochildren type-child' : item.type=='child' || item.type=='link', 'type-group' : item.type != 'child' && item.type != 'link'}"
                                            v-bind:data-id="item.id" 
                                            v-bind:data-type="item.type" 
                                            v-bind:data-desc="item.desc" 
                                            v-bind:data-name="item.name" 
                                            v-bind:data-dictionary="item.dictionary" 
                                            v-bind:data-ico="item.ico" 
                                            v-bind:data-style="item.style"
                                            v-bind:data-url="item.url" 
                                            >
                                            <button class="dd-collapse" data-action="collapse" type="button" v-if="item.type != 'child' && item.type != 'link'">Collapse</button>
                                            <button class="dd-expand" data-action="expand" type="button" v-if="item.type != 'child' && item.type != 'link'">Expand</button>
                                            <div class="dd-handle">
                                                <div class="item_title">{{item.name}}</div>
                                            </div> 
                                            <div class="item_tools">
                                                <i class="fas fa-trash-alt delete_item" @click="deleteItem()"></i>
                                                <i class="fas fa-edit edit_item" v-if="item.type=='child' || item.type=='link'" @click="editLink()"></i>                                  
                                                <i class="fas fa-edit edit_item" v-else @click="editGroup()" ></i>    
                                            </div>
                                            <ol class="dd-list" v-if="item.children"><!--- Depth 2 --->
                                                <li v-for="item in item.children"
                                                    class="dd-item" 
                                                    v-bind:class="{'dd-nochildren type-child' : item.type=='child' || item.type=='link', 'type-group' : item.type != 'child' && item.type != 'link'}"
                                                    v-bind:data-id="item.id" 
                                                    v-bind:data-type="item.type" 
                                                    v-bind:data-desc="item.desc" 
                                                    v-bind:data-name="item.name" 
                                                    v-bind:data-dictionary="item.dictionary" 
                                                    v-bind:data-ico="item.ico" 
                                                    v-bind:data-style="item.style"
                                                    v-bind:data-url="item.url" 
                                                    >
                                                    <button class="dd-collapse" data-action="collapse" type="button" v-if="item.type != 'child' && item.type != 'link'">Collapse</button>
                                                    <button class="dd-expand" data-action="expand" type="button" v-if="item.type != 'child' && item.type != 'link'">Expand</button>
                                                    <div class="dd-handle">
                                                        <div class="item_title">{{item.name}}</div>
                                                    </div> 
                                                    <div class="item_tools">
                                                        <i class="fas fa-trash-alt delete_item" @click="deleteItem()"></i>
                                                        <i class="fas fa-edit edit_item" v-if="item.type=='child' || item.type=='link'" @click="editLink()"></i>                                  
                                                        <i class="fas fa-edit edit_item" v-else @click="editGroup()" ></i>    
                                                    </div>
                                                    <ol class="dd-list" v-if="item.children"><!--- Depth 3 --->
                                                        <li v-for="item in item.children"
                                                            class="dd-item" 
                                                            v-bind:class="{'dd-nochildren type-child' : item.type=='child' || item.type=='link', 'type-group' : item.type != 'child' && item.type != 'link'}"
                                                            v-bind:data-id="item.id" 
                                                            v-bind:data-type="item.type" 
                                                            v-bind:data-desc="item.desc" 
                                                            v-bind:data-name="item.name" 
                                                            v-bind:data-dictionary="item.dictionary" 
                                                            v-bind:data-ico="item.ico" 
                                                            v-bind:data-style="item.style" 
                                                            v-bind:data-url="item.url"
                                                            >
                                                            <button class="dd-collapse" data-action="collapse" type="button" v-if="item.type != 'child' && item.type != 'link'">Collapse</button>
                                                            <button class="dd-expand" data-action="expand" type="button" v-if="item.type != 'child' && item.type != 'link'">Expand</button>
                                                            <div class="dd-handle">
                                                                <div class="item_title">{{item.name}}</div>
                                                            </div> 
                                                            <div class="item_tools">
                                                                <i class="fas fa-trash-alt delete_item" @click="deleteItem()"></i>
                                                                <i class="fas fa-edit edit_item" v-if="item.type=='child' || item.type=='link'" @click="editLink()"></i>                                  
                                                                <i class="fas fa-edit edit_item" v-else @click="editGroup()" ></i>    
                                                            </div>
                                                            <ol class="dd-list" v-if="item.children"><!--- Depth 4 --->
                                                                <li v-for="item in item.children"
                                                                    class="dd-item" 
                                                                    v-bind:class="{'dd-nochildren type-child' : item.type=='child' || item.type=='link', 'type-group' : item.type != 'child' && item.type != 'link'}"
                                                                    v-bind:data-id="item.id" 
                                                                    v-bind:data-type="item.type" 
                                                                    v-bind:data-desc="item.desc" 
                                                                    v-bind:data-name="item.name" 
                                                                    v-bind:data-dictionary="item.dictionary" 
                                                                    v-bind:data-ico="item.ico" 
                                                                    v-bind:data-style="item.style" 
                                                                    v-bind:data-url="item.url"
                                                                    >
                                                                    <button class="dd-collapse" data-action="collapse" type="button" v-if="item.type != 'child' && item.type != 'link'">Collapse</button>
                                                                    <button class="dd-expand" data-action="expand" type="button" v-if="item.type != 'child' && item.type != 'link'">Expand</button>
                                                                    <div class="dd-handle">
                                                                        <div class="item_title">{{item.name}}</div>
                                                                    </div> 
                                                                    <div class="item_tools">
                                                                        <i class="fas fa-trash-alt delete_item" @click="deleteItem()"></i>
                                                                        <i class="fas fa-edit edit_item" v-if="item.type=='child' || item.type=='link'" @click="editLink()"></i>                                  
                                                                        <i class="fas fa-edit edit_item" v-else @click="editGroup()" ></i>    
                                                                    </div>
                                                                    <ol class="dd-list" v-if="item.children"><!--- Depth 5 --->
                                                                        <li v-for="item in item.children"
                                                                            class="dd-item" 
                                                                            v-bind:class="{'dd-nochildren type-child' : item.type=='child' || item.type=='link', 'type-group' : item.type != 'child' && item.type != 'link'}"
                                                                            v-bind:data-id="item.id" 
                                                                            v-bind:data-type="item.type" 
                                                                            v-bind:data-desc="item.desc" 
                                                                            v-bind:data-name="item.name" 
                                                                            v-bind:data-dictionary="item.dictionary" 
                                                                            v-bind:data-ico="item.ico" 
                                                                            v-bind:data-style="item.style" 
                                                                            v-bind:data-url="item.url"
                                                                            >
                                                                            <button class="dd-collapse" data-action="collapse" type="button" v-if="item.type != 'child' && item.type != 'link'">Collapse</button>
                                                                            <button class="dd-expand" data-action="expand" type="button" v-if="item.type != 'child' && item.type != 'link'">Expand</button>
                                                                            <div class="dd-handle">
                                                                                <div class="item_title">{{item.name}}</div>
                                                                            </div> 
                                                                            <div class="item_tools">
                                                                                <i class="fas fa-trash-alt delete_item" @click="deleteItem()"></i>
                                                                                <i class="fas fa-edit edit_item" v-if="item.type=='child' || item.type=='link'" @click="editLink()"></i>                                  
                                                                                <i class="fas fa-edit edit_item" v-else @click="editGroup()" ></i>    
                                                                            </div>
                                                                        </li>                            
                                                                    </ol>
                                                                </li>                            
                                                            </ol>
                                                        </li>                            
                                                    </ol>
                                                </li>                            
                                            </ol>
                                        </li>                            
                                    </ol>
                                </li>                            
                            </ol>
                        </div>
                    </div>
                    <div class="ui-form-list-btn flex-end">
                        <div @click="saveModal" >
                            <a class="ui-wrk-btn ui-wrk-btn-success margin-right-5 margin-bottom-5" v-if="xevent=='add'">Save</a>
                            <a class="ui-wrk-btn ui-wrk-btn-success margin-right-5 margin-bottom-5" v-else></i> Update</a>
                        </div>
                        <!--- <li class="nav-item">
                            <a class="nav-link" href="#md&event=list"><i class="fas fa-list-ul"></i> Menu List</a>
                        </li>   --->
                    </div>
                    </div>                
                </div>
            </div>
            <div class="rw">
                <div class="cl-12 text-danger" v-if="error.length">
                    <strong>Error :</strong>{{ error }}
                </div>               
            </div>
        </div>
    </main>
    <!-- page-content" -->
    </div>
    <!-- Modal -->
    <div class="modal fade" id="addGroupModal" tabindex="-1" role="dialog" aria-labelledby="addGroupLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-white border-0">
            <h5 class="modal-title text-muted" id="addGroupLabel">Üst Menü Grubu Ekle</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            </div>
            <div class="modal-body">
            <form name="addGroup" id="addGroup">
                <div class="form-group">
                <label for="groupName">Grup Adı</label>
                <div class="input-group">
                    <input type="text" class="form-control" id="gdictionary_id" name="gdictionary_id" hidden>
                    <input type="text" class="form-control"  id="groupName" placeholder="Grup Adı">
                    <div class="input-group-append">
                    <span class="input-group-text" id=""><i class="fas fa-book" onclick="windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=addGroup.gdictionary_id&amp;lang_item_name=addGroup.groupName','list');return false"></i></span>
                    </div>                
                </div>              
                </div>
                <div class="form-group">
                <label for="groupName">Grup İcon</label>
                <div class="input-group">
                    <input type="text" class="form-control" id="groupIcon" placeholder="Grup İcon">
                    <div class="input-group-append">
                    <span class="input-group-text" id=""><i class="fa fa-paint-brush" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_icons&is_popup=1&field_name=groupIcon','medium');"></i></span>
                    </div>                
                </div>                  
                </div>
                <div class="form-group">
                <label for="groupName">Grup Style</label>
                <input type="text" class="form-control" id="groupStyle" placeholder="Grup Style">
                </div>
                <div class="form-group">
                <label for="groupDesc">Açıklama</label>
                <textarea class="form-control" id="groupDesc" rows="3"></textarea>
                </div>
            </form>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-primary" @click="addSwapBasketGroup()">Ekle</button>
            </div>
        </div>
        </div>
    </div>
    <div class="modal fade" id="editGroupModal" tabindex="-1" role="dialog" aria-labelledby="editGroupLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-white border-0">
            <h5 class="modal-title text-muted" id="addGroupLabel">Üst Menü Grubu Güncelle</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            </div>
            <div class="modal-body">
            <form name="editGroup" id="editGroup">
                <div class="form-group">
                <label for="groupName">Grup Adı</label>
                <div class="input-group">
                    <input type="text" class="form-control" id="newgdictionary_id" name="newgdictionary_id" hidden>
                    <input type="text" class="form-control"  id="newgroupName" placeholder="Grup Adı">
                    <div class="input-group-append">
                    <span class="input-group-text" id=""><i class="fas fa-book" onclick="windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=editGroup.newgdictionary_id&amp;lang_item_name=editGroup.newgroupName','list');return false"></i></span>
                    </div>                
                </div>              
                </div>
                <div class="form-group">
                <label for="groupName">Grup İcon</label>
                <div class="input-group">
                    <input type="text" class="form-control" id="newgroupIcon" placeholder="Grup İcon">
                    <div class="input-group-append">
                    <span class="input-group-text" id=""><i class="fa fa-paint-brush" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_icons&is_popup=1&field_name=newgroupIcon','medium');"></i></span>
                    </div>                
                </div>                  
                </div>
                <div class="form-group">
                <label for="groupName">Grup Style</label>
                <input type="text" class="form-control" id="newgroupStyle" placeholder="Grup Style">
                </div>
                <div class="form-group">
                <label for="groupDesc">Açıklama</label>
                <textarea class="form-control" id="newgroupDesc" rows="3"></textarea>
                </div>
            </form>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-primary" @click="saveEditGroup()">Güncelle</button>
            </div>
        </div>
        </div>
    </div>
    <div class="modal fade" id="addLinkModal" tabindex="-1" role="dialog" aria-labelledby="addLinkLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-white border-0">
            <h5 class="modal-title text-muted" id="addLinkLabel">Bağlantı Ekle</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            </div>
            <div class="modal-body">
            <form name="addLink" id="addLink">
                <div class="form-group">
                <label for="groupName">Bağlantı Adı</label>
                <div class="input-group">
                    <input type="text" class="form-control" id="dictionary_id" name="dictionary_id" hidden>
                    <input type="text" class="form-control" id="linkName" name="linkName" placeholder="Bağlantı Adı">
                    <div class="input-group-append">
                        <span class="input-group-text" id=""><i class="fas fa-book" onclick="windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=addLink.dictionary_id&amp;lang_item_name=addLink.linkName','list');return false"></i></span>
                    </div>                
                </div>              
                </div>
                <div class="form-group">
                    <label for="groupName">Bağlantı Url</label>
                    <input type="text" class="form-control" id="linkUrl" placeholder="Bağlantı Url">
                </div>
                <div class="form-group">
                    <label for="groupName">Bağlantı İcon</label>                
                    <div class="input-group">
                        <input type="text" class="form-control" id="linkIcon" placeholder="Bağlantı İcon">
                        <div class="input-group-append">
                            <span class="input-group-text" id=""><i class="fa fa-paint-brush" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_icons&is_popup=1&field_name=linkIcon','medium');"></i></span>
                        </div>                
                    </div>   
                </div>
                <div class="form-group">
                    <label for="groupName">Sayfa Style</label>
                    <input type="text" class="form-control" id="linkStyle" placeholder="Sayfa Style">
                </div>
                <div class="form-group">
                    <label for="groupDesc">Açıklama</label>
                    <textarea class="form-control" id="linkDesc" rows="3"></textarea>
                </div>
            </form>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-primary" @click="addSwapBasketLink()">Ekle</button>
            </div>
        </div>
        </div>
    </div>
    <div class="modal fade" id="editLinkModal" tabindex="-1" role="dialog" aria-labelledby="editLinkModal" aria-hidden="true">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-white border-0">
            <h5 class="modal-title text-muted">Bağlantı Güncelle</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            </div>
            <div class="modal-body">
            <form name="editLink" id="editLink">
                <div class="form-group">
                <label for="groupName">Bağlantı Adı</label>
                <div class="input-group">
                    <input type="text" class="form-control" id="newdictionary_id" name="newdictionary_id" hidden>
                    <input type="text" class="form-control" id="newlinkName" name="newlinkName" placeholder="Bağlantı Adı">
                    <div class="input-group-append">
                        <span class="input-group-text" id=""><i class="fas fa-book" onclick="windowopen('index.cfm?fuseaction=settings.popup_list_lang_settings&amp;is_use_send&amp;lang_dictionary_id=editLink.newdictionary_id&amp;lang_item_name=editLink.newlinkName','list');return false"></i></span>
                    </div>                
                </div>              
                </div>
                <div class="form-group">
                    <label for="groupName">Bağlantı Url</label>
                    <input type="text" class="form-control" id="newlinkUrl" placeholder="Bağlantı Url">
                </div>
                <div class="form-group">
                    <label for="groupName">Bağlantı İcon</label>                
                    <div class="input-group">
                        <input type="text" class="form-control" id="newlinkIcon" placeholder="Bağlantı İcon">
                        <div class="input-group-append">
                            <span class="input-group-text" id=""><i class="fa fa-paint-brush" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_icons&is_popup=1&field_name=newlinkIcon','medium');"></i></span>
                        </div>                
                    </div>  
                </div>
                <div class="form-group">
                    <label for="groupName">Sayfa Style</label>
                    <input type="text" class="form-control" id="newlinkStyle" placeholder="Sayfa Style">
                </div>
                <div class="form-group">
                    <label for="groupDesc">Açıklama</label>
                    <textarea class="form-control" id="newlinkDesc" rows="3"></textarea>
                </div>
            </form>
            </div>
            <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-primary" @click="saveEditLink()">Save</button>
            </div>
        </div>
        </div>
    </div>
    <div class="modal fade" id="saveMenuModal" tabindex="-1" role="dialog" aria-labelledby="saveMenuModal" aria-hidden="true">
        <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header bg-white border-0">
            <h5 class="modal-title text-muted" v-if="xevent=='add'" >Add New Menu</h5>
            <h5 class="modal-title text-muted" v-else>Update Menu</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
            </div> 
            <div class="modal-body">
            <form name="saveMenu" id="saveMenu">
                <div class="form-group form-check">
                <input type="checkbox" class="form-check-input" id="menuStatus" v-model="saveMenuForm[0].status" true-value="1" false-value="0">
                <label class="form-check-label" for="menuStatus">Aktif</label>
                </div>
                <div class="form-group">
                <label for="menuName">Menü Adı</label>
                <input type="text" class="form-control" id="menuName" placeholder="Menü Adı" v-model="saveMenuForm[0].name">             
                </div>
                <div class="form-group">
                <label for="bestPractise">Best Practise</label>
                <select class=" form-control" id="bestParctice" multiple v-model="saveMenuForm[0].bestPractise">
                    <option v-for="item in bestPractice" v-bind:value="item[0]">{{item[1]}}</option>
                </select>          
                </div>
                <div class="form-group">
                <label for="menuAuthor">Author</label>
                <input type="text" class="form-control" id="menuAuthor" placeholder="Author" v-model="saveMenuForm[0].menuAuthor">             
                </div> 
            </form>
            </div>
            <div class="modal-footer">
                <label v-if="xevent!='add'" class="float-left">S:{{saveMenuForm[0].record_date}} U: {{saveMenuForm[0].update_date}}</label>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" @click="saveMenu()">Save</button>
            </div>
        </div>
        </div>
    </div>
</div>
 <script>   
    let uri = window.location.href.split('?');
    if (uri.length == 2)
    {
      let vars = uri[1].split('&');
      getVars = {};
      let tmp = '';
      vars.forEach(function(v){
        tmp = v.split('=');
        if(tmp.length == 2)
        getVars[tmp[0]] = tmp[1];
      });      
    }
    var wmd = new Vue({
        el: '#design-app',
        data: {
            xevent:'add',
            menuId:0,
            updateJson:[],
            solutions: [],
            familys: [],
            modules:  [],
            objects: [],
            basket:[],
            bestPractice:[],
            saveMenuForm : [{
              method : 'SET_MENU',
              name:'',
              status:1,
              bestPractise:[],
              menuAuthor:'',
              menuJson:'',
              id:'',
              record_date:'',
              update_date:''
            }],
            error: [],
            msg : 'test'
        },        
        mounted () {
            axios
                .get( "/WDO/workdev/cfc/menuDesigner.cfc", {params: {method : 'GET_SOLUTIONS'}})
                .then(response => {this.solutions = response.data.DATA;})
                .catch(e => {wmd.error.push({ecode: 700, message:"GET_SOLUTIONS"}) });
            axios
                .get( "/WDO/workdev/cfc/menuDesigner.cfc", {params: {method : 'GET_BESTPACTICE'}})
                .then(response => {
                  this.bestPractice = response.data.DATA;
                })
                .catch(e => {wmd.error.push({ecode: 800, message:"GET_BESTPACTICE"}) });           
        },
        methods: {
            randomNumber : function(){
              return (Math.floor(Math.random() * 10000) + 10000).toString().substring(1);
            },
            getFamily: function (solution) {
                axios.get( "/WDO/workdev/cfc/menuDesigner.cfc", {params: {method : 'GET_FAMILYS', solution:solution}}).then(response => {this.familys = response.data.DATA;}).catch(e => {wmd.error.push({ecode: 801, message:"GET_FAMILYS"}) })
            },
            getModule: function (family) {
                axios.get( "/WDO/workdev/cfc/menuDesigner.cfc", {params: {method : 'GET_MODULES', family:family}}).then(response => {this.modules = response.data.DATA;}).catch(e => {wmd.error.push({ecode: 802, message:"GET_MODULES"}) })
            },
            getObject: function (module) {
                axios.get( "/WDO/workdev/cfc/menuDesigner.cfc", {params: {method : 'GET_OBJECTS', module:module}}).then(response => {this.objects = response.data.DATA;}).catch(e => {wmd.error.push({ecode: 803, message:"GET_OBJECTS"}) })
            },
            addSwapBasket: function(id,name,url,dic,style,icon,desc){
              wmd.basket.push({
                id            :wmd.randomNumber(),
                name          :name,
                url           :url,
                dictionary_id :dic,
                style         :style,
                icon          :icon,
                description   :desc,
                type          :'child'
              })
            },
            addSwapBasketGroup: function(){
              wmd.basket.push({
                id            :wmd.randomNumber(),
                name          :$('#groupName').val(),
                url           :null,
                dictionary_id :$('#gdictionary_id').val(),
                style         :$('#groupStyle').val(),
                icon          :$('#groupIcon').val(),
                description   :$('#groupDesc').val(),             
                type          :'group'
              })
              $('#addGroup').trigger('reset');
              $('#groupDesc').empty();
              $('#addGroupModal').modal('hide');
            },
            addSwapBasketLink: function(){
              wmd.basket.push({
                id            :wmd.randomNumber(),
                name          :$('#linkName').val(),
                url           :$('#linkUrl').val(),
                dictionary_id :$('#dictionary_id').val(),
                style         :$('#linkStyle').val(),
                icon          :$('#linkIcon').val(),
                description   :$('#linkDesc').val(),             
                type          :'link'
                })
                $('#addLink').trigger('reset');
                $('#linkDesc').empty();
                $('#addLinkModal').modal('hide');
            },
            deleteItem: function(){
              var item = $(event.toElement).closest('li')[0].dataset.id;
              $('#menu-basket, #swap-basket').nestable('remove', item, function(){
                  if($('#menu-basket').nestable('serialize').length == 0 && !$('#menu-basket').find('.dd-empty').length){
                    $('#menu-basket').find('.dd-list').remove();
                    $('#menu-basket').nestable('destroy');
                  }
              });
              $('#menu-basket, #swap-basket').nestable('remove', item);
            },
            editLink: function(){
                ell = $(event.toElement).closest('li')[0];
                itm = ell.dataset;
                console.log(itm);
                $('#newdictionary_id').val(itm.dictionary);
                $('#newlinkName').val(itm.name);
                $('#newlinkUrl').val(itm.url);
                $('#newlinkIcon').val(itm.ico);
                $('#newlinkStyle').val(itm.style);
                $('#newlinkDesc').html(itm.desc);
                $('#editLinkModal').modal('show');              
            },
            saveEditLink : function(){
                $(ell).find('.item_title').html($('#newlinkName').val());
                $(ell).attr({
                'data-name'       :$('#newlinkName').val(),
                'data-dictionary' :$('#newdictionary_id').val(),
                'data-ico'        :$('#newlinkIcon').val(),
                'data-style'      :$('#newlinkStyle').val(),
                'data-url'        :$('#newlinkUrl').val(),
                'data-desc'       :$('#newlinkDesc').val()
                });
                $(ell).data({
                'name'       :$('#newlinkName').val(),
                'dictionary' :$('#newdictionary_id').val(),
                'ico'        :$('#newlinkIcon').val(),
                'style'      :$('#newlinkStyle').val(),
                'url'        :$('#newlinkUrl').val(),
                'desc'       :$('#newlinkDesc').val()
                })
                $('#editLink').trigger('reset');
                $('#newlinkDesc').empty();
                $('#editLinkModal').modal('hide');
            },
            editGroup: function(){
                ellg = $(event.toElement).closest('li')[0];
                itmg = ellg.dataset;
                $('#newgdictionary_id').val(itmg.dictionary);
                $('#newgroupName').val(itmg.name);
                $('#newgroupIcon').val(itmg.ico);
                $('#newgroupStyle').val(itmg.style);
                $('#newgroupDesc').val(itmg.desc);
                $('#editGroupModal').modal('show');             
            },
            saveEditGroup : function(){
                $(ellg).find('.item_title').each(function(index){
                    $(this).html($('#newgroupName').val());
                     return false;
                })
                $(ellg).attr({
                    'data-name'       :$('#newgroupName').val(),
                    'data-dictionary' :$('#newgdictionary_id').val(),
                    'data-ico'        :$('#newgroupIcon').val(),
                    'data-style'      :$('#newgroupStyle').val(),
                    'data-desc'       :$('#newgroupDesc').val()
                })
                $(ellg).data({
                    'name'       :$('#newgroupName').val(),
                    'dictionary' :$('#newgdictionary_id').val(),
                    'ico'        :$('#newgroupIcon').val(),
                    'style'      :$('#newgroupStyle').val(),
                    'desc'       :$('#newgroupDesc').val()
                });
                $('#editGroup').trigger('reset');
                $('#newgroupDesc').empty();
                $('#editGroupModal').modal('hide');
            },
            saveModal : function(){
              if($('#menu-basket').nestable('serialize').length == 0){
                alertObject({message:'Menu Boş! Sepetteki Nesneler İle Menü Oluşturunuz...',container:'alertMessage'});
              }else{
                $('#saveMenuModal').modal('show');  
              }
            },
            saveMenu : function(){
              wmd.saveMenuForm[0].menuJson = JSON.stringify($('#menu-basket').nestable('serialize'));
              axios.post( "/WDO/workdev/cfc/menuDesigner.cfc?method="+wmd.saveMenuForm[0].method, wmd.saveMenuForm[0])
              .then(response => {
                    if(this.xevent=="update"){
                        if(response.data==500){
                            $('#saveMenuModal').modal('hide');
                            alertObject({message:'Menü Güncellendi',container:'alertMessage',type:"success"});
                        }else{
                            alertObject({message:'Başarısız...  Kontrol Edip Tekrar Deneyiniz.',container:'alertMessage'});
                        }                        
                    }else{
                          if(response.data > 0){
                            $('#saveMenuModal').modal('hide');
                            alertObject({message:'Menü Kaydedildi',container:'alertMessage',type:"success"});
                            setTimeout(function(){
                                window.location.href = "/index.cfm?fuseaction=dev.menudesigner&event=upd&menu="+response.data;
                            }, 2000);                            
                        }else{
                            alertObject({message:'Başarısız...  Kontrol Edip Tekrar Deneyiniz.',container:'alertMessage'});
                        }  
                    }
                  })
              .catch(e => {wmd.error.push({ecode: 900, message:"saveMenu"}) })
            }
        },
        watch: {
            xevent: function () {
                if(this.xevent="update"){
                    axios
                        .get( "/WDO/workdev/cfc/menuDesigner.cfc", {params: {method : 'GET_MENU',MID:this.menuId}})
                        .then(response => {
                            wmd.updateJson = JSON.parse( response.data.DATA[0][2] );
                            wmd.saveMenuForm[0].id = response.data.DATA[0][0];
                            wmd.saveMenuForm[0].name = response.data.DATA[0][1];
                            wmd.saveMenuForm[0].status = response.data.DATA[0][3];
                            wmd.saveMenuForm[0].bestPractise[0] = response.data.DATA[0][4];
                            wmd.saveMenuForm[0].menuAuthor = response.data.DATA[0][5];
                            wmd.saveMenuForm[0].record_date = response.data.DATA[0][6];
                            wmd.saveMenuForm[0].update_date = response.data.DATA[0][7];
                            $('#menu-basket').find('.dd-empty').remove();
                            $('#menu-basket').nestable({maxDepth:5});              
                        })
                        .catch(e => {wmd.error.push({ecode: 901, message:"event upd set"}) });
                 }
            }
        }    
    })

    
    $( document ).off('click', '.sidebar-dropdown > a'); // duplicate function clear
    $( document ).on( "click", ".sidebar-dropdown > a", function() {  
        $(".sidebar-submenu").slideUp(200);
        if ($(this).parent().hasClass("active")) {
            $(".sidebar-dropdown").removeClass("active");
            $(this).parent().removeClass("active");
        } else {
            $(".sidebar-dropdown").removeClass("active");
            $(this).next(".sidebar-submenu").slideDown(200);
            $(this).parent().addClass("active");
        }   
    });
    $( document ).off('click', '.sidebar-submenu ul li>a'); // duplicate function clear
    $( document ).on( "click", ".sidebar-submenu ul li>a", function() {  
        $(this).closest('ul').find(".sidebar-submenu").slideUp(200);             
        if ($(this).parent().hasClass("active")) {
            $(this).parent().removeClass("active");
        } else {
            $(this).closest('ul').find("li").removeClass("active");
            $(this).next(".sidebar-submenu").slideDown(200); 
            $(this).parent().addClass("active");            
        }   
           
    });

      
    $("#close-sidebar").click(function() {
        $(".page-wrapper").removeClass("toggled");
    });

    $("#show-sidebar").click(function() {
        $(".page-wrapper").addClass("toggled");
    });  
   
    if(getVars.menu){
        wmd.saveMenuForm[0].method='UPD_MENU';
        wmd.xevent='update';
        wmd.menuId=getVars.menu;        
    }else{
        $('#menu-basket').find('.dd-list').remove();
    }
    $('#menu-basket').nestable({maxDepth:5}); 
    $('#swap-basket').nestable({maxDepth:5});

</script>