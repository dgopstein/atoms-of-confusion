select uc.userid||'.'||uc.codeid from usercode uc join tag t on uc.codeid=ct.codeid join codetags ct on t.id=ct.tagid where tag in ("remove_INDENTATION_atom", "Indentation");
