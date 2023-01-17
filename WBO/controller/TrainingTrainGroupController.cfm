<cfscript>
    if(attributes.tabMenuController eq 0)
    {
        WOStruct = StructNew();
        WOStruct['#attributes.fuseaction#'] = structNew();
        WOStruct['#attributes.fuseaction#']['default'] = 'list';
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
        WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
        WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'training.list_training_groups';
        WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/training/display/list_training_groups.cfm';
        WOStruct['#attributes.fuseaction#']['list']['queryPath'] = 'V16/training/display/list_training_groups.cfm';

        if(isDefined("attributes.train_group_id") and len(attributes.train_group_id))
        {
            WOStruct['#attributes.fuseaction#']['upd'] = structNew();
            WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'training.list_training_groups';
            WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/training/display/list_training_group_detail.cfm';
            WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/training/display/list_training_group_detail.cfm';

            WOStruct['#attributes.fuseaction#']['det'] = structNew();
            WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'training.list_training_groups';
            WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'V16/training/display/list_training_group_trainers.cfm';
            WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'V16/training/display/list_training_group_trainers.cfm';

            WOStruct['#attributes.fuseaction#']['randomQuestion'] = structNew();
            WOStruct['#attributes.fuseaction#']['randomQuestion']['window'] = 'normal';
            WOStruct['#attributes.fuseaction#']['randomQuestion']['fuseaction'] = 'training.lesson';
            WOStruct['#attributes.fuseaction#']['randomQuestion']['filePath'] = 'V16/training/display/training_groups_random_question.cfm';
            WOStruct['#attributes.fuseaction#']['randomQuestion']['queryPath'] = 'V16/training/display/training_groups_random_question.cfm';

            WOStruct['#attributes.fuseaction#']['joinClass'] = structNew();
            WOStruct['#attributes.fuseaction#']['joinClass']['window'] = 'emptypopup';
            WOStruct['#attributes.fuseaction#']['joinClass']['fuseaction'] = 'training.list_training_groups';
            WOStruct['#attributes.fuseaction#']['joinClass']['filePath'] = 'V16/training/display/join_class.cfm';
            WOStruct['#attributes.fuseaction#']['joinClass']['queryPath'] = 'V16/training/display/join_class.cfm';
        }

      }
</cfscript>