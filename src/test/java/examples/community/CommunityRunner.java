package examples.community;

import com.intuit.karate.junit5.Karate;

class CommunityRunner {
    
    @Karate.Test
    Karate testcommunity() {
        return Karate.run("community").relativeTo(getClass());
    }    

}
