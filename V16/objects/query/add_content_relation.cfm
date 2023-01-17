<cfset cfc= createObject("component","V16.content.cfc.get_content")>
<cfset add_content_relation=cfc.GetAddContentRelationInsert(action_type:attributes.action_type,action_type_id:attributes.action_type_id,cid:attributes.cid)>  

