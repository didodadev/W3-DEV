<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';

        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training.lesson';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training/display/list_lessons.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/training/display/list_lessons.cfm';

        if(isDefined("attributes.lesson_id") and len(attributes.lesson_id))
        {
            WOStruct['#attributes.fuseaction#']['det'] = structNew();
            WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'training.lesson';
            WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/training/display/list_lessons_detail.cfm';
            WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/training/display/list_lessons_detail.cfm';

            WOStruct['#attributes.fuseaction#']['addHomeworkAnswer'] = structNew();
            WOStruct['#attributes.fuseaction#']['addHomeworkAnswer']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['addHomeworkAnswer']['fuseaction'] = 'training.lesson';
            WOStruct['#attributes.fuseaction#']['addHomeworkAnswer']['filePath'] = 'V16/training/display/add_homework_answer.cfm';
            WOStruct['#attributes.fuseaction#']['addHomeworkAnswer']['queryPath'] = 'V16/training/display/add_homework_answer.cfm';

            WOStruct['#attributes.fuseaction#']['randomQuestion'] = structNew();
            WOStruct['#attributes.fuseaction#']['randomQuestion']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['randomQuestion']['fuseaction'] = 'training.lesson';
            WOStruct['#attributes.fuseaction#']['randomQuestion']['filePath'] = 'V16/training/display/random_question.cfm';
            WOStruct['#attributes.fuseaction#']['randomQuestion']['queryPath'] = 'V16/training/display/random_question.cfm';
        }
      }
</cfscript>