<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training.content';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training/display/list_content.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/training/display/list_content.cfm';

        if(isDefined("attributes.cntid") and len(attributes.cntid))
        {
            WOStruct['#attributes.fuseaction#']['det'] = structNew();
            WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'training.content';
            WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/training/display/list_content_detail.cfm';
            WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/training/display/list_content_detail.cfm';
            
            WOStruct['#attributes.fuseaction#']['randomQuestion'] = structNew();
            WOStruct['#attributes.fuseaction#']['randomQuestion']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['randomQuestion']['fuseaction'] = 'training.lesson';
            WOStruct['#attributes.fuseaction#']['randomQuestion']['filePath'] = 'V16/training/display/training_content_random_question.cfm';
            WOStruct['#attributes.fuseaction#']['randomQuestion']['queryPath'] = 'V16/training/display/training_content_random_question.cfm';

            WOStruct['#attributes.fuseaction#']['feedBack'] = structNew();
            WOStruct['#attributes.fuseaction#']['feedBack']['window'] = 'popup';
            WOStruct['#attributes.fuseaction#']['feedBack']['fuseaction'] = 'training.content';
            WOStruct['#attributes.fuseaction#']['feedBack']['filePath'] = 'V16/training/display/training_feedback.cfm';
            WOStruct['#attributes.fuseaction#']['feedBack']['queryPath'] = 'V16/training/display/training_feedback.cfm';

        }
      }
</cfscript>