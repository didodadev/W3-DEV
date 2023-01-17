<cfif session.ep.design_id neq 1 and session.ep.design_id neq 2>
  <cfif session.ep.menu_id neq 0>
    <script src="/JS/assets/plugins/menuDesigner/vue.js"></script>
    <script src="/JS/assets/plugins/menuDesigner/axios.min.js"></script>
    <style>
      .noIco{
          font-weight: 800;
          text-transform: uppercase;
          text-decoration: none;
          font-size: 14px !important;
          padding-left: 2px;
          padding-right: 1px;
          font-style: unset;
      }
    </style>
  </cfif>

  <div class="leftBar">
    <div class="nav-side-menu">
      <div class="brand">
        <input type="text" id="leftMenuSearch" autocomplete="off" placeholder="<cfoutput>#getLang('myhome',655)#</cfoutput>"/>
        &nbsp;<div class="search"><i class="catalyst-magnifier"></i></div>
      </div>
      <div id="responseSearch" class="hide"></div>
      <div class="menu-list" id="sidebar-menu">
        <cfif session.ep.menu_id neq 0>
          <ul class="menu-content closeMenu menuSA">
            <li class="menuItem" v-for="item in menuJson" >
              <a :href="createUrl(item.type,item.url)" :style="item.style">
                  <i v-bind:class="item.ico" v-if="item.ico"></i>
                  <i v-else class="noIco">{{item.name | noIcon}}</i>
                  <span class="title">{{getLang(item)}}</span>
                  <span v-if="item.children" class="arrow"></span>               
              </a>
              <ul v-if="item.children" class="sub-menu">
                  <li v-for="item in item.children">
                    <a :href="createUrl(item.type,item.url)" :style="item.style">
                        <i v-bind:class="item.ico" v-if="item.ico"></i>
                        <i v-else class="noIco">{{item.name | noIcon}}</i>
                        <span class="title" >{{getLang(item)}}</span>
                        <span v-if="item.children" class="arrow"></span>  
                    </a>
                    <ul v-if="item.children" class="sub-menu">
                      <li v-for="item in item.children">
                        <a :href="createUrl(item.type,item.url)" :style="item.style">
                            <i v-bind:class="item.ico" v-if="item.ico"></i>
                            <i v-else class="noIco">{{item.name | noIcon}}</i>
                            <span class="title">{{getLang(item)}}</span>
                            <span v-if="item.children" class="arrow"></span>  
                        </a>
                        <ul v-if="item.children" class="sub-menu">
                          <li v-for="item in item.children">
                            <a :href="createUrl(item.type,item.url)" :style="item.style">
                                <i v-bind:class="item.ico" v-if="item.ico"></i>
                                <i v-else class="noIco">{{item.name | noIcon}}</i>
                                <span class="title">{{getLang(item)}}</span>
                                <span v-if="item.children" class="arrow"></span>  
                            </a>
                            <ul v-if="item.children" class="sub-menu">
                              <li v-for="item in item.children">
                                <a :href="createUrl(item.type,item.url)" :style="item.style">
                                    <i v-bind:class="item.ico" v-if="item.ico"></i>
                                    <i v-else class="noIco">{{item.name | noIcon}}</i>
                                    <span class="title">{{getLang(item)}}</span>
                                    <span v-if="item.children" class="arrow"></span>  
                                </a>
                                <ul v-if="item.children" class="sub-menu">
                                  <li v-for="item in item.children">
                                    <a :href="createUrl(item.type,item.url)" :style="item.style">
                                        <i v-bind:class="item.ico" v-if="item.ico"></i>
                                        <i v-else class="noIco">{{item.name | noIcon}}</i>
                                        <span class="title">{{getLang(item)}}</span>
                                        <span v-if="item.children" class="arrow"></span>  
                                    </a>
                                  </li>
                                </ul>
                              </li>
                            </ul>
                          </li>
                        </ul>
                      </li>
                    </ul>
                  </li>
                </ul>
            </li>
          </ul>
        </cfif>
      </div>
    </div>
  </div>
  <cfif session.ep.menu_id neq 0>
    <script>
        var wmd = new Vue({
          el: '#sidebar-menu',
          data: {
            menuJson: [],          
            error: []
          },
          methods: {
              createUrl : function(type,url){
                var curl ='javascript:void(0)';
                if(type=='child'){
                  curl='/index.cfm?fuseaction='+url;
                }else if(type=='link'){
                  curl=url;
                }
                return curl;
              },
              getLang: function (item) {
                if (item.dictionary){
                  axios
                      .get( "/WDO/workdev/cfc/menuDesigner.cfc", {params: {method : 'GET_LANG', dictionary_id:item.dictionary}})
                      .then(function (response) { item.name = response.data;})
                      .catch(function (error) {console.log(error); });
                  
                }
                return item.name;
              }
          },
          filters: {
            noIcon: function (value) {
              if (!value) return ''
              value = value.toString()
              return value.substring(0,2);
            }          
          },
          mounted () {
              axios
                  .get( "/WDO/workdev/cfc/menuDesigner.cfc", {params: {method : 'GET_USER_MENUS'}})
                  .then(response => {
                    this.menuJson = JSON.parse(response.data.DATA[0][2]);
                  })
                  .catch(e => {wmd.error.push({ecode: 1000}) });         
          }   
        })
    </script> 
  </cfif>
<cfelse>
  
  <div class="holistic-menu">   
    <cfparam name="attributes.solution" default="">
    <cfparam name="attributes.family" default="">
    <cfparam name="attributes.module" default="">
    <script src="/JS/assets/plugins/menuDesigner/vue.js"></script>
    <script src="/JS/assets/plugins/menuDesigner/axios.min.js"></script>
    <link rel="stylesheet" href="V16/myhome/display/holistic_menu/index.css?version=270420210327">
    <div id="jelibon-menu" class="holistic_container">
      <div class="holistic_top">
        <div class="holistic_top_search">
          <i class="fa fa-arrow-left" v-if="keyword.length > 2" @click="show_menu('module')"></i>
          <i class="fa fa-search" v-else></i>
          <cfsavecontent variable="place"><cf_get_lang dictionary_id='61041.arama yap'>...</cfsavecontent>
          <input type="text" v-model="keyword" placeholder="<cfoutput>#place#</cfoutput>" autocomplete="off"/>
          <select v-model="object_type_val">
            <option v-for="(item,name) in object_type" :value="item.id">{{item.type}}</option>
          </select>
         <!---  <i class="fa fa-microphone"></i> --->
          <i class="fa fa-microphone fa-3x holistic-speech" @click="listen">
            <i class="light-ring"></i><i class="light-ring-two"></i>
          </i>
        </div>        
        <div @click="holisticClose();" class="holistic_menu_close">
          <a href="javascript://">x</a>
        </div>
      </div>
   
     <div class="holistic_body" v-if="keyword.length < 3 " >
        <cfif session.ep.design_id eq 1>
          <div class="holistic_body_item" v-if="show_type == 'module'" v-show="show_group[0].app == true">
            <div class="holistic_body_item_title">
              <a href="javascript://" @click="toggleGroup();">
                <i class="fa fa-chevron-down"></i>
                <cf_get_lang dictionary_id="51495.Uygulamalar"> 
              </a>
            <span class="count">{{app_count}}</span>
            </div>
            <div class="holistic_body_item_list">
              <div class="item_box" v-for="(item,name) in modules" data-item="app" v-if="item[0].MODULE_NO != 47  &&  item[0].MODULE_NO != 42 && item[0].MODULE_NO != 7 && item[0].MODULE_NO != 84 && item[0].MODULE_NO != 44 && item[0].MODULE_NO != 105 && item[0].MODULE_NO != 30 && item[0].MODULE_NO != 83 && item[0].MODULE_TYPE == 1  <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1><cfelse> && item[0].STATUS == 'Deployment'</cfif>">
                <a href="javascript://" class="icon" @click="show_menu('object',item[0].MODULE_NO)">  
                    <i v-if="new_tag_modules.indexOf(name) >= 0" class="holistic-new-module"><cf_get_lang dictionary_id='58674.Yeni'></i>               
                    <i :class="'iconBoxes font-style-normal ' + item[0].MODULE_ICON" v-if="item[0].MODULE_ICON"></i>
                    <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(name,'class')]" v-else>{{name | first}}</i>                        
                    <span>{{name}}</span>
                    <i v-show="false">{{show_group[0].app = true}}</i>                 
                </a>
              </div>  
            </div>
          </div>
        <cfelse>
          <div class="holistic_body_item" v-if="show_type == 'module'" v-for="(item,name) in modules">
            <div class="holistic_body_item_title">
              <a href="javascript://" class="" @click="toggleGroup();"><i class="fa fa-chevron-down"></i>
                {{ name }}
              </a>
              <span class="count">{{Object.keys( item.modules ).length}}</span>
            </div>
            <div class="holistic_body_item_list">
              <div class="item_box" v-for="(objectItem,objectName) in item.modules" data-item="app" v-if = "Object.keys( item.modules ).length > 0" <!--- v-if="item[0].MODULE_NO != 47  &&  item[0].MODULE_NO != 42 && item[0].MODULE_NO != 7 && item[0].MODULE_NO != 84 && item[0].MODULE_NO != 44 && item[0].MODULE_NO != 105 && item[0].MODULE_NO != 30 && item[0].MODULE_NO != 83 && item[0].MODULE_TYPE == 1  <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1><cfelse> && item[0].STATUS == 'Deployment'</cfif>" --->>
                <a href="javascript://" class="icon" @click="show_menu('watomic_family_object',objectItem[0].WATOMIC_FAMILY_TITLE)">  
                    <!--- <i v-if="new_tag_modules.indexOf(name) >= 0" class="holistic-new-module"><cf_get_lang dictionary_id='58674.Yeni'></i>   --->             
                    <i :class="'iconBoxes font-style-normal ' + objectItem[0].WRK_WATOMIC_FAMILY_ICON" v-if="objectItem[0].WRK_WATOMIC_FAMILY_ICON"></i>
                    <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(name,'class')]" v-else>{{name | first}}</i>                        
                    <span>{{objectName}}</span>
                    <!--- <i v-show="false">{{show_group[0].app = true}}</i> --->                 
                </a>
              </div>  
            </div>
          </div>
        </cfif>
          <div class="holistic_left">
            <div class="holistic_body_item-type2" v-show="show_type == 'object' || show_type == 'watomic_family_object'">
              <div class="holistic_body_item_title">
                <cfif session.ep.design_id eq 1>
                  <a href="javascript://" @click="show_menu('module')" class="title"><span :class="module_icon"></span><cf_get_lang dictionary_id="51495.Uygulamalar"> <i class="fa fa-chevron-right"></i>{{module_title}}</a>
                <cfelse>
                  <a href="javascript://" @click="show_menu('module')" class="title"><span :class="module_icon"></span>{{watomic_solution_title}}<i class="fa fa-chevron-right"></i>{{watomic_family_title}}</a>
                </cfif>
              </div>                   
              <div class="holistic_body_item-left">
                <!--- Loop Başlangıç WBO --->
                  <div class="holistic_body_item" v-show="show_group[0].func == true">
                    <div class="holistic_body_item_title">
                      <a href="javascript://" class="title"><i class="icon-detail"></i><cf_get_lang dictionary_id="61040.İş Fonksiyonları"></a>
                    </div>
                    <div class="holistic_body_item_list">
                      <div class="item_box" v-for="(item,name) in objects"  v-if="item.OBJECT_TYPE == 0  <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1><cfelse> && item.STATUS == 'Deployment'</cfif>">
                        <div class="icon">  
                          <a :href="item.urlOptions.href" v-on:click="eval(item.urlOptions.event)">
                            <i v-if="item.VERSION.length > 0 && item.VERSION.toLowerCase() == 'beta'" class="holistic-beta"><cf_get_lang dictionary_id='62038.Beta'></i>   
                            <i v-else-if="item.MAIN_VERSION.length > 0 && item.MAIN_VERSION == main_version" class="holistic-new"><cf_get_lang dictionary_id='58674.Yeni'></i>                                             
                            <i :class="'iconBoxes font-style-normal ' + item.OBJECT_ICON" v-if="item.OBJECT_ICON"></i>
                            <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(item.OBJECT_TITLE,'class')]" v-else>{{item.OBJECT_TITLE | first}}</i>                        
                            <span>{{item.OBJECT_TITLE}}</span>
                          </a>
                          <cfif session.ep.design_id eq 1>
                            <i v-show="false">{{module_title=item.MODULE_TITLE}} {{module_icon=item.MODULE_ICON}} {{show_group[0].func = true}}</i>
                          <cfelse>           
                            <i v-show="false">{{watomic_solution_title=item.WATOMIC_SOLUTION_TITLE}}{{watomic_family_title=item.WATOMIC_FAMILY_TITLE}}{{show_group[0].func = true}}</i>
                          </cfif>
                        </div>
                      </div>
                    </div>
                  </div>
                <!--- Loop Bitiş WBO --->
                <!--- Loop Başlangıç Raporlar --->
                  <div class="holistic_body_item" v-show="show_group[0].report == true">
                    <div class="holistic_body_item_title">
                      <a href="javascript://" class="title"><i class="icon-chart"></i><cf_get_lang dictionary_id='57626.Raporlar'></a>
                    </div>
                    <div class="holistic_body_item_list">
                      <div class="item_box" v-for="(item,name) in objects"  v-if="item.OBJECT_TYPE == 8 || item.OBJECT_TYPE == 13  <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1><cfelse> && item.STATUS == 'Deployment'</cfif>">
                        <div class="icon">  
                          <a :href="item.urlOptions.href" v-on:click="eval(item.urlOptions.event)">                     
                            <i :class="'iconBoxes font-style-normal ' + item.OBJECT_ICON" v-if="item.OBJECT_ICON"></i>
                            <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(item.OBJECT_TITLE,'class')]" v-else>{{item.OBJECT_TITLE | first}}</i>                        
                            <span>{{item.OBJECT_TITLE}}</span>
                          </a>
                          <cfif session.ep.design_id eq 1>
                            <i v-show="false">{{module_title=item.MODULE_TITLE}} {{module_icon=item.MODULE_ICON}} {{show_group[0].report = true}}</i>             
                          <cfelse>           
                            <i v-show="false">{{watomic_solution_title=item.WATOMIC_SOLUTION_TITLE}}{{watomic_family_title=item.WATOMIC_FAMILY_TITLE}}{{show_group[0].report = true}}</i>
                          </cfif>          
                        </div>
                      </div>
                    </div>
                  </div>
                <!--- Loop Bitiş Raporlar --->
              </div>
              <div class="holistic_body_item-right">
                <!--- Loop Başlangıç Parametre --->
                <div class="holistic_body_item" v-show="show_group[0].param == true">
                  <div class="holistic_body_item_title">
                    <a href="javascript://" class="title"><i class="fa fa-sliders"></i><cf_get_lang dictionary_id='57693.Parametreler'></a>
                  </div>
                  <div class="holistic_body_item_list">
                    <div class="item_box" v-for="(item,name) in objects" v-if="item.OBJECT_TYPE == 1  <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1><cfelse> && item.STATUS == 'Deployment'</cfif>">
                      <div class="icon">  
                        <a :href="item.urlOptions.href" v-on:click="eval(item.urlOptions.event)">                     
                          <i :class="'iconBoxes font-style-normal ' + item.OBJECT_ICON" v-if="item.OBJECT_ICON"></i>
                          <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(item.OBJECT_TITLE,'class')]" v-else>{{item.OBJECT_TITLE | first}}</i>                        
                          <span>{{item.OBJECT_TITLE}}</span>
                        </a>
                        <cfif session.ep.design_id eq 1>
                          <i v-show="false">{{module_title=item.MODULE_TITLE}} {{module_icon=item.MODULE_ICON}} {{show_group[0].param = true}}</i>
                        <cfelse>           
                          <i v-show="false">{{watomic_solution_title=item.WATOMIC_SOLUTION_TITLE}}{{watomic_family_title=item.WATOMIC_FAMILY_TITLE}}{{show_group[0].param = true}}</i>
                        </cfif>               
                      </div>
                    </div>
                  </div>
                </div>
                <!--- Loop Bitiş Parametre --->
                <!--- Loop Başlangıç Utility --->
                <div class="holistic_body_item" v-show="show_group[0].utility == true">
                  <div class="holistic_body_item_title">
                    <a href="javascript://" class="title"><i class="icon-cogs"></i><cf_get_lang dictionary_id='60175.Utility'></a>
                  </div>
                  <div class="holistic_body_item_list">
                    <div class="item_box" v-for="(item,name) in objects" v-if="item.OBJECT_TYPE == 6  <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1><cfelse> && item.STATUS == 'Deployment'</cfif>">
                      <div class="icon">  
                        <a :href="item.urlOptions.href" v-on:click="eval(item.urlOptions.event)">                     
                          <i :class="'iconBoxes font-style-normal ' + item.OBJECT_ICON" v-if="item.OBJECT_ICON"></i>
                          <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(item.OBJECT_TITLE,'class')]" v-else>{{item.OBJECT_TITLE | first}}</i>                        
                          <span>{{item.OBJECT_TITLE}}</span>
                        </a>
                        <cfif session.ep.design_id eq 1>
                          <i v-show="false">{{module_title=item.MODULE_TITLE}} {{module_icon=item.MODULE_ICON}} {{show_group[0].utility = true}}</i>             
                        <cfelse>           
                          <i v-show="false">{{watomic_solution_title=item.WATOMIC_SOLUTION_TITLE}}{{watomic_family_title=item.WATOMIC_FAMILY_TITLE}}{{show_group[0].utility = true}}</i>
                        </cfif> 
                      </div>
                    </div>
                  </div>
                </div>
                <!--- Loop Bitiş Utility --->
                <!--- Loop Başlangıç Aktarımlar --->
                <div class="holistic_body_item" v-show="show_group[0].transfer == true">
                  <div class="holistic_body_item_title">
                    <a href="javascript://" class="title"><i class="icon-download"></i><cf_get_lang dictionary_id='29673.Aktarımlar'></a>
                  </div>
                  <div class="holistic_body_item_list">
                    <div class="item_box" v-for="(item,name) in objects" v-if="item.OBJECT_TYPE == 3  <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1><cfelse> && item.STATUS == 'Deployment'</cfif>">
                      <div class="icon">  
                        <a :href="item.urlOptions.href" v-on:click="eval(item.urlOptions.event)">                     
                          <i :class="'iconBoxes font-style-normal ' + item.OBJECT_ICON" v-if="item.OBJECT_ICON"></i>
                          <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(item.OBJECT_TITLE,'class')]" v-else>{{item.OBJECT_TITLE | first}}</i>                        
                          <span>{{item.OBJECT_TITLE}}</span>
                        </a>
                        <cfif session.ep.design_id eq 1>
                          <i v-show="false">{{module_title=item.MODULE_TITLE}} {{module_icon=item.MODULE_ICON}} {{show_group[0].transfer = true}}</i>             
                        <cfelse>           
                          <i v-show="false">{{watomic_solution_title=item.WATOMIC_SOLUTION_TITLE}}{{watomic_family_title=item.WATOMIC_FAMILY_TITLE}}{{show_group[0].transfer = true}}</i>
                        </cfif>  
                      </div>
                    </div>
                  </div>
                </div>
                <!--- Loop Bitiş Aktarımlar --->
                <!--- İçerik ve Yardım Başlangıç --->
                <div class="holistic_body_item">
                  <div class="holistic_body_item_list">
                    <div class="item_box">
                      <div class="icon">  
                        <a href="https://wiki.workcube.com/" target="_blank">                      
                          <img src="css/assets/icons/catalyst-icon-svg/wiki-logo.svg" style=" margin: 0 10px 0 0!important; width: 18px; ">
                          <span class="const">Wiki</span>
                        </a>            
                      </div>
                    </div>
                    <div class="item_box">
                      <div class="icon">  
                        <a href="https://www.workcube.com/workcubetv" target="_blank">                      
                          <img src="css/assets/icons/catalyst-icon-svg/academy-logo.svg" style=" margin: -1px 5px 0px -6px !important; width: 29px; ">
                          <span class="const"><cf_get_lang dictionary_id='64063.Eğitim Videoları'></span>
                        </a>            
                      </div>
                    </div>
                    <div class="item_box">
                      <div class="icon">  
                        <a href="https://wiki.workcube.com/forum" target="_blank">                      
                          <img src="css/assets/icons/catalyst-icon-svg/ctl-text-lines.svg" style=" margin: 0 10px 0 0!important; width: 18px; ">
                          <span class="const"><cf_get_lang dictionary_id='57421.Forum'></span>
                        </a>            
                      </div>
                    </div>
                  </div>
                </div>
                <!--- İçerik ve Yardım Bitiş --->
              </div>
            </div>
          </div>
          <div class="holistic_body_item" v-if="show_type == 'module'" v-show="show_group[0].addon == true">
            <div class="holistic_body_item_title">
              <a href="javascript://" @click="toggleGroup();">
                <i class="fa fa-chevron-down"></i>
                <cf_get_lang dictionary_id='51496.Eklentiler'> 
              </a>
              <span class="count">{{addon_count}}</span>
            </div>
            <div class="holistic_body_item_list">
              <div class="item_box" v-for="(item,name) in modules" data-item="addon" v-if="item[0].MODULE_NO != 47 && item[0].MODULE_NO != 42 && item[0].MODULE_NO != 7 && item[0].MODULE_NO != 84 && item[0].MODULE_NO != 44 && item[0].MODULE_NO != 105 && item[0].MODULE_NO != 30 && item[0].MODULE_NO != 83 && item[0].MODULE_TYPE == 2  <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1><cfelse> && item[0].STATUS == 'Deployment'</cfif>">
                <a href="javascript://" class="icon" @click="show_menu('object',item[0].MODULE_NO)">
                    <i v-if="new_tag_modules.indexOf(name) >= 0" class="holistic-new-module"><cf_get_lang dictionary_id='58674.Yeni'></i>               
                    <i :class="'iconBoxes font-style-normal ' + item[0].MODULE_ICON" v-if="item[0].MODULE_ICON"></i>
                    <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(name,'class')]" v-else>{{name | first}}</i>                        
                    <span>{{name}}</span> 
                    <i v-show="false">{{show_group[0].addon = true}}</i>                         
                </a>
            </div>
            </div>
          </div>  
          <div class="holistic_body_item" v-if="show_type == 'module'" v-show="show_group[0].fav == true">
            <div class="holistic_body_item_title">
              <a href="javascript://" @click="toggleGroup();">
                <i class="fa fa-chevron-down"></i>
                Sık Kullanılanlar 
              </a>
              <span class="count">{{menuFavorite.length}}</span>
            </div>
            <div class="holistic_body_item_list">
              <div class="item_box" v-for="(item) in menuFavorite">
                  <a class="icon" :data-fuseaction="item[1]" :href="item[1]">                        
                      <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(item[2])]">{{item[2] | first}}</i>                        
                      <span>{{item[2]}}</span>
                      <i v-show="false">{{show_group[0].fav = true}}</i>                  
                  </a>
              </div>
            </div>
          </div>
          <div class="holistic_body_item" v-if="show_type == 'module'" v-show="show_group[0].system == true">
            <div class="holistic_body_item_title">
              <a href="javascript://" @click="toggleGroup();">
                <i class="fa fa-chevron-down"></i>
                <cf_get_lang dictionary_id='58147.Sistem'>
              </a> 
              <span class="count">{{system_count}}</span>
            </div>
            <div class="holistic_body_item_list">
            <div class="item_box" v-for="(item,name) in modules" data-item="system" v-if="item[0].MODULE_NO == 42 || item[0].MODULE_NO == 7 || item[0].MODULE_NO == 84 || item[0].MODULE_NO == 44 ||item[0].MODULE_NO == 105 ||item[0].MODULE_NO == 30 || item[0].MODULE_NO == 83  <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1><cfelse> && item[0].STATUS == 'Deployment'</cfif>">
                  <a href="javascript://" class="icon" @click="show_menu('object',item[0].MODULE_NO)">                        
                      <i :class="'iconBoxes font-style-normal ' + item[0].MODULE_ICON" v-if="item[0].MODULE_ICON"></i>
                      <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(name,'class')]" v-else>{{name | first}}</i>                        
                      <span>{{name}}</span>
                      <i v-show="false">{{show_group[0].system = true}}</i>                      
                  </a>
              </div>
            </div>  
          </div>
      </div>       

     <div class="holistic_body holistic_search" v-else>
          <div class="holsitic_top_search_count" v-if="keyword.length > 2">{{filtered.length}} Sonuç Bulundu</div>
          <div class="holistic_body_item" v-for="(item,name) in filtered" v-if="item.OBJECT_TYPE == object_type_val || object_type_val == -1">
              <div class="holistic_body_item_title">
                <a :href="item.urlOptions.href" v-on:click="eval(item.urlOptions.event)">
                  <i :class="'iconBoxes font-style-normal ' + item.MODULE_ICON" v-if="item.MODULE_ICON"></i>
                  <i :class="['iconBoxes backgr font-style-normal color-'+$options.filters.first(name,'class')]" v-else>{{name | first}}</i>                      
                  <span>{{item.OBJECT_TITLE}} <small> • {{item.MODULE_TITLE}}</small></span> 
                </a>
              </div>
              <div class="breadcrumb">
                  {{item.SOLUTION_TITLE}} > {{item.FAMILY_TITLE}} > {{item.MODULE_TITLE}}
              </div>
              <div class="links">
                  <a href="javascript://"  v-if="item.OBJECT_TYPE == 0">WBO</a>
                  <a href="javascript://" v-if="item.OBJECT_TYPE == 1">Param</a>
                  <a href="javascript://"  v-if="item.OBJECT_TYPE == 2">System</a>
                  <a href="javascript://"  v-if="item.OBJECT_TYPE == 3">Import</a>
                  <a href="javascript://"  v-if="item.OBJECT_TYPE == 4">Period</a>
                  <a href="javascript://"  v-if="item.OBJECT_TYPE == 5">Maintenance</a>
                  <a href="javascript://"  v-if="item.OBJECT_TYPE == 6"><cf_get_lang dictionary_id='60175.Utility'></a>
                  <a href="javascript://"  v-if="item.OBJECT_TYPE == 7">Dev</a>
                  <a href="javascript://"  v-if="item.OBJECT_TYPE == 8">Report</a>
                  <a href="javascript://"  v-if="item.OBJECT_TYPE == 9">General</a>
                  <a href="javascript://"  v-if="item.OBJECT_TYPE == 10">Child WO</a>
                  <a href="javascript://"  v-if="item.OBJECT_TYPE == 11">Query-Backend</a>
                  <a href="javascript://"  v-if="item.OBJECT_TYPE == 12">Export</a>
                  <a href="javascript://"  v-if="item.OBJECT_TYPE == 13">Dashboard</a>
                  <a :href="'/index.cfm?fuseaction=dev.wo&event=upd&fuseact='+ item.FUSEACTION + '&woid=' + item.WRK_OBJECTS_ID" target="_blank"><i class="fa fa-code" aria-hidden="true"></i>WorkDev</a>
                  <cfif session.ep.language eq "eng">
                    <cfset site_language_path = "en">
                  <cfelseif session.ep.language eq "DE">  
                    <cfset site_language_path = "de">
                  <cfelseif session.ep.language eq "tr">  
                    <cfset site_language_path = "tr">
                  <cfelse>
                    <cfset site_language_path = "en">
                  </cfif>
                  <a :href="'https://wiki.workcube.com/<cfoutput>#site_language_path#</cfoutput>/category_detail?keyword='+item.OBJECT_TITLE" target="_blank"><i class="fa fa-info-circle" aria-hidden="true"></i>Wiki</a>
              </div>               
            </div>
          </div>
      </div>
    </div>
  </div>
  <cfquery name="jsonVersion" datasource="#dsn#">
    DECLARE @version VARCHAR(4000)
    SELECT TOP 1 @version = COALESCE(FORMAT(UPDATE_DATE,'ddmmyyyyhhmm'),'S') FROM WRK_SOLUTION ORDER BY UPDATE_DATE DESC
    SELECT TOP 1 @version += COALESCE(FORMAT(UPDATE_DATE,'ddmmyyyyhhmm'),'F') FROM WRK_FAMILY ORDER BY UPDATE_DATE DESC
    SELECT TOP 1 @version += COALESCE(FORMAT(UPDATE_DATE,'ddmmyyyyhhmm'),'M') FROM WRK_MODULE ORDER BY UPDATE_DATE DESC
    SELECT TOP 1 @version += COALESCE(FORMAT(UPDATE_DATE,'ddmmyyyyhhmm'),'O') FROM WRK_OBJECTS ORDER BY UPDATE_DATE DESC
    SELECT @version as vs
  </cfquery>
  <cfset GET_RELEASE_NO = createObject("V16.settings.cfc.workcube_license").get_license_information() />
  <cfif session.ep.design_id eq 1>
    <cfset options = {
      getUrl: '#file_web_path#personal_settings/userGroup_jelibon_menu_#session.ep.language#_#GET_USER_GROUP_MENU#.json?v=#jsonVersion.vs#',
      groupItem: 'MODULE_TITLE'
    } />
  <cfelse>
    <cfset options = {
      getUrl: '#file_web_path#personal_settings/userGroup_watomic_menu_#session.ep.language#_#GET_USER_GROUP_MENU#.json?v=#jsonVersion.vs#',
      groupItem: 'WATOMIC_SOLUTION_TITLE'
    } />
  </cfif>
  <script>
    try {
      var SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
      var recognition = new SpeechRecognition();
      this.recognition.lang = "tr";
      this.recognition.onresult = this.record;
    }
    catch(e) {
      console.error(e);
      $('.no-browser-support').show();
      $('.app').hide();
    }
    /*holistic-menu claslı menuyu acar */
    $( ".page-logo" ).click(function() {
      $('div.holistic-menu').fadeToggle("400");
      $('body').toggleClass('overflow');
      $(".holistic_top_search input").focus();
    });
    
    var wjm = new Vue({
        el: '#jelibon-menu',
        data: {
            menuJson: [],
            modules : [],
            objects : [],
            new_tag_modules : [],
            menuFavorite : [], 
            module_title : false,
            module_icon : false,
            watomic_solution_title: "",
            watomic_family_title: "",
            solution_id : 0,
            family_id : 0,
            module_id : 0,
            keyword : '',
            main_version : '', 
            show_type : 'module',
            show_group: [{
              transfer : false,
              func : false,
              report : false,
              param : false,
              fav : false,
              addon : false,
              app : false,
              system : false,
              utility: false
            }],
            object_type_val : -1,
            object_type : [
              {id:-1,type:"<cf_get_lang dictionary_id='57708.All'>"},
              {id:0,type:"WBO"},
              {id:1,type:"Param"},
              {id:2,type:"System"},
              {id:3,type:"Import"},
              {id:4,type:"Period"},
              {id:5,type:"Maintenance"},
              {id:6,type:"<cf_get_lang dictionary_id='60175.Utility'>"},
              {id:7,type:"Dev"},
              {id:8,type:"Report"},
              {id:9,type:"General"},
              {id:12,type:"Export"},
              {id:13,type:"Dashboard"}
            ],            
            app_count : 0,
            system_count : 0,
            addon_count : 0,
            error: [],
            return : [{
              speechToText: [],
              isListening: false,
              recognition: [null]
            }]
        },
        methods: {   
          listen : function(){
              this.isListening = true;
              this.recognition.start();
              $('.holistic-speech').addClass('echo-dot')
            },
            record : function(event){
              me = this;
              this.isListening = false;
              this.speechToText = event.results[0][0].transcript;
              console.log(this.speechToText);
              me.keyword = this.speechToText;
              $('.holistic-speech').removeClass('echo-dot')
            },         
            group: function (xs, key) {
                if(xs){
                    return xs.reduce(function(rv, x) {
                        (rv[x[key]] = rv[x[key]] || []).push(x);
                        return rv;
                    }, {});
                }else{
                    return [];
                }
            },
            createUrlOptions: function(item){
              item.WINDOW = (item.WINDOW != '' && item.WINDOW != null) ? item.WINDOW.toLowerCase() : '';
              item.POPUP_TYPE = (item.POPUP_TYPE != '' && item.POPUP_TYPE != null) ? item.POPUP_TYPE.toLowerCase() : '';

              var url = '<cfoutput>#request.self#</cfoutput>?fuseaction='+item.FUSEACTION, urlOptions = {};

              if( item.WINDOW == 'popup' ) urlOptions = {href: 'javascript://', event: "windowopen('/"+url+"','"+item.POPUP_TYPE+"' )" }
              else if( item.WINDOW == 'draggable' ) urlOptions = {href: 'javascript://', event: "openBoxDraggable('"+url+"')" }
              else urlOptions = {href: url, event: '' };

              item.urlOptions = urlOptions;
              return item;
            },
            show_menu: function (type,id){
                me = this;
                me.keyword = '';
                me.show_group = [{ transfer : false, func : false, report : false, param : false, fav : false, addon : false, app : false, system : false, utility : false }];
                switch(type) {
                    case 'module':
                        this.show_type = "module";                     
                    break;
                    case 'object':
                        this.show_type = "object";
                        me.objects = me.group(me.menuJson,"MODULE_NO")[id].map((item) => {return this.createUrlOptions(item);});
                    break;
                    case 'watomic_family_object':
                        this.show_type = "watomic_family_object";
                        me.objects = me.group(me.menuJson,"WATOMIC_FAMILY_TITLE")[id].map((item) => {return this.createUrlOptions(item);});
                    break;
                   
                };
            },
            toggleGroup: function(e){
              var item_toggle = $(event.target).closest('.holistic_body_item_title').find('a');
              $(item_toggle).toggleClass('active');
              $(item_toggle).parents('div.holistic_body_item').find('div.holistic_body_item_list').fadeToggle("400");
            },
            holisticClose: function(e){
              $('div.holistic-menu').fadeToggle("400");
              $('body').toggleClass('overflow');
            },
            trReplace : function (keyword){
              return keyword.replace(/[Iıİi]/gi,"i").replace(/[ğüşçö]/gi,"").toLowerCase().trim().length || 0;
            },
        },
        filters: {            
            noIcon: function (value) {
              if (!value) return ''
              value = value.toString()
              return value.substring(0,2).toUpperCase();
            },
            first: function (value,c) {
              if (!value) return ''
              value = value.toString()
              var first_letter = value.substring(0,1).toUpperCase();
              if (c == 'class'){
                switch(first_letter) {
                  case 'Ğ':
                    first_letter = 'G';
                    break;
                  case 'Ü':
                    first_letter = 'U';
                    break;
                  case 'Ş':
                    first_letter = 'S';
                    break;
                  case 'İ':
                    first_letter = 'I';
                    break;
                  case 'Ö':
                    first_letter = 'O';
                    break;
                  case 'Ç':
                    first_letter = 'C';
                    break;
                }
              }
              return first_letter;
            }
      
        },
        mounted () {
            /* this.recognition = new webkitSpeechRecognition();
            this.recognition.lang = "tr";
            this.recognition.onresult = this.record; */
            me = this;
            var solution_version = '<cfoutput>#GET_RELEASE_NO.RELEASE_NO#</cfoutput>';
            me.main_version = solution_version.trim();
            axios
                .get( "<cfoutput>#options.getUrl#</cfoutput>")
                .then(function (response) { 
                    me.menuJson = response.data['DATA'];
                    <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1>
                      me.modules = me.group(response.data['DATA'],'<cfoutput>#options.groupItem#</cfoutput>');
                    <cfelse>
                      me.modules = me.group(me.group(response.data['DATA'],'STATUS').Deployment,'<cfoutput>#options.groupItem#</cfoutput>');
                    </cfif>
                    <cfif session.ep.design_id eq 2>
                      for( i in me.modules ){
                        me.modules[i]['modules'] = me.group( me.modules[i], 'WATOMIC_FAMILY_TITLE' );
                      }
                    </cfif>
                    try {
                      new_ = response.data['DATA'].filter(function(item){/* yeni eklenen objelerin modulleri */
                        if(item.MAIN_VERSION.length > 0 && item.MAIN_VERSION == me.main_version){
                            return item;
                        }
                      });
                      new_ = me.group(new_,'MODULE_TITLE');
                      for(var item in new_){
                        me.new_tag_modules.push(item)
                      }
                    } catch (error) {
                      console.log('ERROR CODE : LN543');
                    }
                })
                .catch(function (error) {console.log(error);});
            axios
                .get( "/WMO/utility.cfc", {params: {method : 'getFavorite',Show_Top_Menu:'false'}})
                .then(function (response) {
                  me.menuFavorite= response.data['DATA'];
                })
                .catch(function (error) {console.log(error); });  
                var keys;            
                  document.addEventListener("keydown", function (e) {
                      keys = (keys || []);
                      keys[e.keyCode]=true;
                      if (keys[27]){
                        console.log("0");
                        me.show_menu('module'); /* modüllere dön */ 
                      }        
                      if (keys[17] && keys[32]){ /* holsitik menü toggle */
                        console.log("1");
                        $('div.holistic-menu').fadeToggle("400");
                        $('body').toggleClass('overflow');                        
                        keys[e.keyCode]=false;
                        stop();
                        $(".holistic_top_search input").focus();
                        $(".holistic_top_search input").val();
                        me.keyword="";
                      }
                  },false);
              
                  document.addEventListener("keyup", function (e) {
                      keys[e.keyCode]=false;
                      return false;
                      stop();
                  },false); 
           
        },
        computed: {
            filtered: function () {
                var source = this.menuJson;
                var keyword = this.keyword;
                searchString = keyword.replace(/[Iıİ]/gi,"i").replace(/[öÖ]/gi,"o").replace(/[şŞ]/gi,"s").replace(/[çÇ]/gi,"c").replace(/[ğĞ]/gi,"g").toLowerCase().trim();
                if(searchString.length >= 3){
                  if(!searchString){
                  return source;
                  }   
                  source = source.filter(function(item){
                  if(item.OBJECT_TITLE.replace(/[Iıİ]/gi,"i").replace(/[öÖ]/gi,"o").replace(/[şŞ]/gi,"s").replace(/[çÇ]/gi,"c").replace(/[ğĞ]/gi,"g").toLowerCase().trim().indexOf(searchString) !== -1){
                      return item;
                  }
                  }).map((item) => {return this.createUrlOptions(item)});
                  function compare(a, b) {
                    if (a.TYPE_RANK < b.TYPE_RANK)
                      return -1;
                    if (a.TYPE_RANK > b.TYPE_RANK)
                      return 1;
                    return 0;
                  }
                  return source.sort(compare);
                }else{
                  return [];
                }
            }  
        },
        watch: {
          modules: function() {
            var source = this.modules;
             wjm.app_count = 0;
             wjm.addon_count = 0;
             wjm.system_count = 0;
              $.each( source, function( key, value ) {
                if(this[0].MODULE_NO != 47  &&  this[0].MODULE_NO != 42 && this[0].MODULE_NO != 7 && this[0].MODULE_NO != 84 && this[0].MODULE_NO != 44 && this[0].MODULE_NO != 105 && this[0].MODULE_NO != 30 && this[0].MODULE_NO != 83 && this[0].MODULE_TYPE == 1  <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1><cfelse> && this[0].STATUS == 'Deployment'</cfif>){
                  wjm.app_count= wjm.app_count+1;
                }
                if(this[0].MODULE_NO != 47 && this[0].MODULE_NO != 42 && this[0].MODULE_NO != 7 && this[0].MODULE_NO != 84 && this[0].MODULE_NO != 44 && this[0].MODULE_NO != 105 && this[0].MODULE_NO != 30 && this[0].MODULE_NO != 83 && this[0].MODULE_TYPE == 2  <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1><cfelse> && this[0].STATUS == 'Deployment'</cfif>){
                  wjm.addon_count= wjm.addon_count+1;
                }
                if(this[0].MODULE_NO == 42 || this[0].MODULE_NO == 7 || this[0].MODULE_NO == 84 || this[0].MODULE_NO == 44 ||this[0].MODULE_NO == 105 ||this[0].MODULE_NO == 30 || this[0].MODULE_NO == 83  <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1><cfelse> && this[0].STATUS == 'Deployment'</cfif>){
                  wjm.system_count= wjm.system_count+1;
                }

              });
          }
        }
    })
  </script> 
</cfif>