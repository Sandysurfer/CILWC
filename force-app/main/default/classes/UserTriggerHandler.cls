public class UserTriggerHandler {
    // I1 user1 True   False
    // I2 user2 True   False
    // I3 user3 False  False

    public static void updateCaseOwner(List<User> newList, Map<Id,User> userOldMap){
        //new - user1 - false, user2 - false, user3 - false
        //Map - <I1 - User1 True>, <I2 - User2 True>,  <I3 - User3 False>  
        //Use Map to Collect <userId, ManagerId>.....
        Map<Id,Id> userMap = new Map<Id,Id>();
        for(User u : newList){
            //Check if new User is inactive and old user is Active
            if(u.isActive == false && userOldMap.get(u.id).isActive == true){
                userMap.put(u.id,u.ManagerId);
            }
        }
        //I1 - M1, I2 - M2...
        List<Case> caseList = [Select Id From Case Where OwnerId IN : userMap.keySet()];
        for(Case c : caseList){
            //Check if Map Contains OwnerId.....
            if(userMap.containsKey(c.OwnerId)){
                c.ownerId = userMap.get(c.ownerId);
            }
        }
        if(caseList.size()>0){
            update caseList;
        }  
    }
    //Task 35: While Creation of New User, Check if Assign Manager(Checkbox) is checked,if then Assign manager to user based on team Selection.....
    public static void assignManagerBasedOnTeam(List<User> newUserList){
        Set<String> teamNameSet = new Set<String>();
        Map<String,User> managerMap = new Map<String,User>();
        
        if(!newUserList.isEmpty()){
            for(User newUser : newUserList){
                //Add TeamName in Set only if Assign_Manager__c Checkbox is checked...
                if(newUser.Team__c != null && newUser.Assign_Manager__c == true){
                    teamNameSet.add(newUser.Team__c);
                }
            }
            if(!teamNameSet.isEmpty()){
                List<User> managerList = [Select Id,Team__c From User Where Team__c IN : teamNameSet AND isActive = TRUE LIMIT 1];
                if(!managerList.isEmpty()){
                    for(User manager : managerList){
                        managerMap.put(manager.Team__c, manager);
                    }
                }
                if(!newUserList.isEmpty()){
                    for(User usrObj : newUserList){
                        if(usrObj.Assign_Manager__c == true){
                            if(!managerMap.isEmpty() && managerMap.containsKey(usrObj.Team__c))
                            {
                                User manager = managerMap.get(usrObj.Team__c);
                                if(manager != null){
                                    usrObj.ManagerId = manager.Id;
                                }
                            }
                            else
                            {
                                usrObj.addError('There is No Other User With Team Name'+usrObj.Team__c+' team');
                            }
                        }
                    }
                }
            }
        }
    }
}