<nav class="navbar navbar fixed-top navbar-expand-lg navbar-light mb-3 border border-top-0 border-right-0 border-left-0 border-grey" style="background-color: #f8f9fa!important;">
  <cfif len(GET_COMPANY.logo)>
    <a class="navbar-brand" aria-label="Toggle navigation">
      <img src="/src/includes/manifest/6_og_image.png" title="<cfoutput>#PRIMARY_DATA.TITLE#</cfoutput> "class="logo-nav" style="width: 40px;" id="btn"/>
    </a> 
  <cfelse>
    <a class="navbar-brand" href="#"><cfoutput>#PRIMARY_DATA.TITLE#</cfoutput></a>
  </cfif>
  <ul class="navbar-nav mr-auto" >
    <cfoutput>                  
        <cfloop array="#GET_DEFAULT_MENU_JSON#" item="ITEM">
          <li <cfif ITEM.type eq "group">class="nav-item dropdown"<cfelse> class="nav-item"</cfif>><a <cfif ITEM.type neq "group"> class="nav-link" href="#ITEM.url#"<cfelse>class="nav-link dropdown-toggle" data-toggle="dropdown"</cfif>>#ITEM.name#</a>
            <cfif ITEM.type eq 'group'>
              <div class="dropdown-menu">
                <cfloop array="#ITEM.CHILDREN#" item="ITEM">
                  <a class="dropdown-item" href="#ITEM.url#">#ITEM.name#</a>
                </cfloop>
              </div>
            </cfif>
          </li>
        </cfloop>
    </cfoutput>
  </ul>
  <div class="collapse navbar-collapse show">
    <!--- <ul class="navbar-nav mr-auto">
      <cfoutput>                  
          <cfloop array="#GET_DEFAULT_MENU_JSON#" item="ITEM">
            <li <cfif ITEM.type eq "group">class="nav-item dropdown"<cfelse> class="nav-item"</cfif>><a <cfif ITEM.type neq "group"> class="nav-link" href="#ITEM.url#"<cfelse>class="nav-link dropdown-toggle" data-toggle="dropdown"</cfif>>#ITEM.name#</a>
              <cfif ITEM.type eq 'group'>
                <div class="dropdown-menu">
                  <cfloop array="#ITEM.CHILDREN#" item="ITEM">
                    <a class="dropdown-item" href="#ITEM.url#">#ITEM.name#</a>
                  </cfloop>
                </div>
              </cfif>
            </li>
          </cfloop>
      </cfoutput>
    </ul> --->
    <ul style="position: absolute;top: 5px;display:flex;top:15px;">
      <li class="navbaricon" style="margin-right:-5px;">
        <a href="<cfoutput>#site_language_path#/WorkcubeSupport</cfoutput>"><img src="/src/includes/manifest/workdesk-logo.svg" style="width: 100px;height: 50px;"></img></a>
      </li>
      <li class="navbaricon" style="padding-right:5px;">
        <a href="https://alltogether.workcube.com/" target="_blank"><img src="/src/includes/manifest/pw3-logo-turuncu.svg" style="width: 50px;height: 50px;"></img></a>
      </li>
      <a class="mobil" style="display:none;" id="mobileIcon">
        <i class="fas fa-search" style="width: 30px;height: 50px;margin-right:12px;color: #ff9f12 !important;"></i>
      </a>
      <li class="navbaricon">
        <a href="#" class="dropdown-toggle" id="dropdownLanguage" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="30px" height="50px" viewBox="0 0 20.617 20.617"><defs><clipPath id="a"><rect width="20.617" height="20.617" fill="#57b8ff"/></clipPath></defs><g clip-path="url(#a)"><path d="M10.3,0A10.309,10.309,0,1,0,20.617,10.309,10.3,10.3,0,0,0,10.3,0m7.144,6.185H14.4a16.037,16.037,0,0,0-1.423-3.67,8.28,8.28,0,0,1,4.465,3.67M10.309,2.1a14.522,14.522,0,0,1,1.969,4.082H8.339A14.552,14.552,0,0,1,10.309,2.1M2.329,12.37a8.554,8.554,0,0,1-.267-2.062,8.547,8.547,0,0,1,.267-2.062H5.814a17.025,17.025,0,0,0-.144,2.062,17.025,17.025,0,0,0,.144,2.062Zm.846,2.062h3.04A16.183,16.183,0,0,0,7.639,18.1a8.23,8.23,0,0,1-4.464-3.67m3.04-8.247H3.175a8.23,8.23,0,0,1,4.464-3.67,16.183,16.183,0,0,0-1.424,3.67m4.094,12.329a14.552,14.552,0,0,1-1.97-4.082h3.939a14.522,14.522,0,0,1-1.969,4.082M12.72,12.37H7.9a15,15,0,0,1-.165-2.062A14.875,14.875,0,0,1,7.9,8.247H12.72a15.035,15.035,0,0,1,.166,2.062,15.167,15.167,0,0,1-.166,2.062m.258,5.732a16.037,16.037,0,0,0,1.423-3.67h3.042a8.284,8.284,0,0,1-4.465,3.67M14.8,12.37a17.025,17.025,0,0,0,.144-2.062A17.025,17.025,0,0,0,14.8,8.247h3.484a8.5,8.5,0,0,1,.268,2.062,8.5,8.5,0,0,1-.268,2.062Z" fill="#57b8ff"/></g></svg>
        </a>
        <div class="dropdown-menu" aria-labelledby="dropdownLanguage">
          <cfoutput>                
            <cfloop collection="#lang_list#" item="item">
                <a class="dropdown-item" href="/#item#">#lang_list[item][1]#</a>
            </cfloop>
          </cfoutput>
        </div>
      </li>
      <li class="navbaricon">
        <a href="<cfoutput>#site_language_path#</cfoutput>"><i class="fas fa-home" style="width: 30px;height: 50px;margin-left:8px;color: #ff9f12 !important;"></i></a>
      </li>
    </ul>
    <ul class="navbar-nav ml-auto">
      <li class="dropdown mx-3 show">
          <a href="#" class="dropdown-toggle language" id="dropdownLanguage" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="20.617" height="20.617" viewBox="0 0 20.617 20.617"><defs><clipPath id="a"><rect width="20.617" height="20.617" fill="#57b8ff"/></clipPath></defs><g clip-path="url(#a)"><path d="M10.3,0A10.309,10.309,0,1,0,20.617,10.309,10.3,10.3,0,0,0,10.3,0m7.144,6.185H14.4a16.037,16.037,0,0,0-1.423-3.67,8.28,8.28,0,0,1,4.465,3.67M10.309,2.1a14.522,14.522,0,0,1,1.969,4.082H8.339A14.552,14.552,0,0,1,10.309,2.1M2.329,12.37a8.554,8.554,0,0,1-.267-2.062,8.547,8.547,0,0,1,.267-2.062H5.814a17.025,17.025,0,0,0-.144,2.062,17.025,17.025,0,0,0,.144,2.062Zm.846,2.062h3.04A16.183,16.183,0,0,0,7.639,18.1a8.23,8.23,0,0,1-4.464-3.67m3.04-8.247H3.175a8.23,8.23,0,0,1,4.464-3.67,16.183,16.183,0,0,0-1.424,3.67m4.094,12.329a14.552,14.552,0,0,1-1.97-4.082h3.939a14.522,14.522,0,0,1-1.969,4.082M12.72,12.37H7.9a15,15,0,0,1-.165-2.062A14.875,14.875,0,0,1,7.9,8.247H12.72a15.035,15.035,0,0,1,.166,2.062,15.167,15.167,0,0,1-.166,2.062m.258,5.732a16.037,16.037,0,0,0,1.423-3.67h3.042a8.284,8.284,0,0,1-4.465,3.67M14.8,12.37a17.025,17.025,0,0,0,.144-2.062A17.025,17.025,0,0,0,14.8,8.247h3.484a8.5,8.5,0,0,1,.268,2.062,8.5,8.5,0,0,1-.268,2.062Z" fill="#57b8ff"/></g></svg>
        </a>
          <div class="dropdown-menu" aria-labelledby="dropdownLanguage">
              <cfoutput>                
              <cfloop collection="#lang_list#" item="item">
                  <a class="dropdown-item" href="/#item#">#lang_list[item][1]#</a>
              </cfloop>
              </cfoutput>
          </div>
      </li>
    </ul>
    <form class="form-inline my-2 my-lg-0 card card-sm border-0" action="<cfoutput>#site_language_path#</cfoutput>/category_detail" method="get" style="background-color:#f8f9fa!important" >
      <div class="card-body row no-gutters align-items-center m-0 p-0 rs" id="SearchToggle">	
			<!--end of col-->
			<div class="col">
				<i class="fas fa-search h4 text-body" style="position: absolute;top: 11px;left: 10px;color: #ff9f12 !important;font-size: 18px;"></i>
				<input class="form-control form-control form-control-borderless searchInput inputW" type="search" name="keyword" id="keyword" value="<cfoutput>#(structKeyExists(attributes,'keyword'))?attributes.keyword:''#</cfoutput>" placeholder="<cf_get_lang dictionary_id='64255.İhtiyaç duyduğunuz bilgiyi arayın'>" style=" padding-left: 35px; padding-right: 5px; min-width: 450px;border-bottom-right-radius: 0px;border-top-right-radius: 0px;">
			</div>
			<!--end of col-->
			<div class="col-auto">
				<button class="btn btn-success searchButton" type="submit" style="border-bottom-left-radius: 0;border-top-left-radius: 0;"><cf_get_lang dictionary_id='57565.Ara'></button>
			</div>
			<!--end of col-->
		</div>
    </form>
  </div>
</nav>
<script>
    var proteinApp = new Vue({
        el: '#top_nav',
        data: {
          vue: 0       
        },
        methods: {
            logOut : function(){
                axios.get( "/cfc/system/login.cfc?method=logOut",{params:{key:200}})
                .then(response => {
                   setTimeout(function(){window.location="/"} , 2000);                              
                })
                .catch(e => {
                   console.log("");
                })
            }
        }       
    });
    $("#mobileIcon").click(function(){
      $("#SearchToggle").toggleClass("flexbox");
    });
</script>