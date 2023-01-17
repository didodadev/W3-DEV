<style type="text/css">
	/*tabbede menu*/
.searchMenu{
	padding: 3px 0;
	margin-left: 0;
	margin-top: 1px;
	margin-bottom: 0;
	font: bold 12px Verdana;
	list-style-type: none;
	text-align: left;
}

.searchMenu li{
	display:inline;
}

.searchMenu li a{
	cursor:pointer;
	text-decoration: none;
	padding: 3px 7px;
	margin-right: 3px;
	color: #2d2b2b;
	background-color:#FFFFFF;
	display:table-cell;
}

.searchMenu li a:visited{
	color: #2d2b2b;
}

.searchMenu li a:hover{
	text-decoration: underline;
	color: #2d2b2b;
}

.searchMenu li.selected{
	position: relative;
	top: 1px;
}

.searchMenu li.selected a{ /*seili tab stili */
	background-color:#6699cc;
	color:#fff;
	border-bottom-color: white;
	display:table-cell;
    background-repeat: no-repeat;
}

.searchMenu li.selected a:hover{ /*seili tab stili*/
	text-decoration: none;
} 

.icerik{
	width: 350px;
	margin-bottom: 1em;
	padding: 10px;
	height:auto;
}

.icerik{border: 1px solid #a7caed;}
.searchMenu li a{ border: 1px solid #a7caed;}
/*tabbede menu*/
</style>

<cfoutput>
	<ul id="searchMenu" class="searchMenu">
		<li <cfif attributes.searchtype eq 1>class="selected"</cfif> id="link1" style="float:left"><a onClick="AjaxPageLoad('#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_search_object&searchType=1&keyword=#attributes.keyword#&maxrows=#attributes.maxrows#&sector=#attributes.sector#','show_search',0,'Loading..',link1);"><cf_get_lang_main no='246.Üye'></a></li>
		<li <cfif attributes.searchtype eq 2>class="selected"</cfif> id="link2" style="float:left"><a onClick="pageload(2,link2);"><cf_get_lang_main no='245.Ürün'></a></li>
		<li <cfif attributes.searchtype eq 3>class="selected"</cfif> id="link3" style="float:left"><a onClick="pageload(3,link3);"><cf_get_lang_main no='115.Talep'></a></li>
	</ul>
    <br /><br />
	<div id="show_search" class="icerik" style="width:100%;height:100%;">
		<cfinclude template="search_object.cfm">
	</div>
	<script type="text/javascript">
		function pageload(page,_link_)
		{
			if(page==2)
				var url_str = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_search_object&searchType="+page+"&keyword=#attributes.keyword#&product_cat=#attributes.product_cat#&product_catid=#attributes.product_catid#&maxrows=#attributes.maxrows#"
			else if(page==3)
				var url_str = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_search_object&searchType="+page+"&keyword=#attributes.keyword#&demand_type=#attributes.demand_type#&sector=#attributes.sector#&member_name=#attributes.member_name#&product_cat=#attributes.product_cat#&product_catid=#attributes.product_catid#&maxrows=#attributes.maxrows#"
			AjaxPageLoad(url_str,'show_search',1,'Loading..',_link_);
		}
	</script>
</cfoutput>


