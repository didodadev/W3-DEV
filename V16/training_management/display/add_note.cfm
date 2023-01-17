<cfsetting showdebugoutput="no">
<cftransaction>
<cfset cfc = createObject('component','V16.training_management.cfc.training_groups')>
<cfset addNote = cfc.add_note_to_attender(
    attender_id: attributes.attender_id,
    attender_note: attributes.attender_note
)>
</cftransaction>