<!---
    File :          AddOns\Yazilimsa\Protein\view\design_blocks\designBlocks.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          09.04.2020
    Description :   Protein sitelerinde kullanılacak bağımsız html design block'ların listesi
--->
<cfparam name="attributes.keyword" default="">
<cfset url_str = "">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.startrow" default=1>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfquery name="PROTEIN_WIDGET" datasource="#dsn#">
    SELECT DESIGN_BLOCK_ID, BLOCK_CONTENT_TITLE, AUTHOR, THUMBNAIL FROM PROTEIN_DESIGN_BLOCKS
    WHERE
        PROTEIN_WIDGET_ID IS NULL
    <cfif isdefined("attributes.is_submit")>        
        AND LOCK_CONTENT_TITLE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
    </cfif>
</cfquery>
<link rel="stylesheet" href="/AddOns/Yazilimsa/Protein/src/assets/css/protein.css?v=22042022" />
<cf_catalystHeader>
<div class="wrapper margin-top-10">
    <div class="search_group">    
        <cf_box>
            <cfform name="search_asset" id="search_asset" action="#request.self#?fuseaction=protein.design_blocks" method="post">
                <input type="hidden" name="is_submit" id="is_submit" value="1">               
                <cf_box_search plus="0">
                    <div class="blog_title font-yellow-gold text-blue" style="margin:5px;">                     
                        <cf_get_lang dictionary_id='65346.Design Block'>                       
                    </div>
                    <div class="form-group xxxlarge" id="item-keyword">
                        <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','What are you looking for?',54983)#">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4" search_function='submitControl()'>
                    </div>
                </cf_box_search>
            </cfform>
        </cf_box>
    </div>
    <div class="ui-row">
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
            <div class="desing_block_list_item desing_block_list_item_add">
                <div class="bg-grey desing_block_list_item_image ">
                    <a href="index.cfm?fuseaction=protein.design_blocks&event=add">                      
                        <i class="fa fa-paint-brush desing-block-add-icon"></i><i class="fa fa-plus desing-block-add-icon"></i>
                    </a>
                </div>
                <div class="desing_block_list_item_text">
                    <div class="desing_block_list_item_text_top">
                        <a href="index.cfm?fuseaction=protein.design_blocks&event=add">
                            <cf_get_lang dictionary_id='42377.Design Block Oluştur'>
                        </a>
                    </div>
                    <div class="desing_block_list_item_text_bottom">
                        <ul>                                
                            <li class="user">                                    
                                <i class="wrk-uF0092"></i>Design Block<br>                                    
                            </li>
                            <li>                                        
                                <a href="index.cfm?fuseaction=protein.design_blocks&event=add">
                                    <i class="catalyst-plus"></i>
                                </a>                                        
                            </li>                                
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <cfoutput query="PROTEIN_WIDGET">
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                <div class="desing_block_list_item">
                    <div class="desing_block_list_item_image">                        
                        <a href="index.cfm?fuseaction=protein.design_blocks&event=upd&design_block_id=#DESIGN_BLOCK_ID#">
                            <img src="/documents/design_blocks_thumbnail/#THUMBNAIL#">
                        </a>
                    </div>
                    <div class="desing_block_list_item_text">
                        <div class="desing_block_list_item_text_top">
                            <a href="index.cfm?fuseaction=protein.design_blocks&event=upd&design_block_id=#DESIGN_BLOCK_ID#">
                                #BLOCK_CONTENT_TITLE#
                            </a>
                        </div>
                        <div class="desing_block_list_item_text_bottom">
                            <ul>                                
                                <li class="user">                                    
                                    <i class="wrk-uF0092"></i>#Author#<br>                                    
                                </li>
                                <li>                                        
                                    <a href="index.cfm?fuseaction=protein.design_blocks&event=upd&design_block_id=#DESIGN_BLOCK_ID#">
                                        <i class="catalyst-eye"></i>
                                    </a>                                        
                                </li>                                
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </cfoutput>	
    </div>
</div>