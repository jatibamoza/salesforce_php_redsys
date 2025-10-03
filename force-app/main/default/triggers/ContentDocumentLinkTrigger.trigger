trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert)  {
	if(!TriggersManager.StopContentDocumentLinkTrigger) {     
        ContentDocumentLinkTrigger_Handler.afterInsert(Trigger.new);
	}
}