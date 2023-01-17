<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training.curriculum';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training/display/list_subjects.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/training/display/list_subjects.cfm';

        if(isDefined("attributes.train_id") and len(attributes.train_id))
        {
            WOStruct['#attributes.fuseaction#']['det'] = structNew();
            WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'training.curriculum';
            WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/training/display/list_subjects_detail.cfm';
            WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/training/display/list_subjects_detail.cfm';
        }
      }
</cfscript>