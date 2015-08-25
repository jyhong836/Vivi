//
//  InvisiblePresence.hpp
//  Vivi
//
//  Created by Junyuan Hong on 8/25/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#pragma once

#ifndef __cplusplus
#error not c++
#endif

#import <Swiften/Elements/Presence.h>

namespace Swift {
    class SWIFTEN_API InvisiblePresence: public Presence {
    public:
        typedef boost::shared_ptr<InvisiblePresence> ref;
    
        InvisiblePresence(): invisible_(true) {};
        InvisiblePresence(bool invisible): invisible_(invisible) {}
        SWIFTEN_DEFAULT_COPY_CONSTRUCTOR(InvisiblePresence)
        ~InvisiblePresence() {}
        
        static ref create() {
            return boost::make_shared<InvisiblePresence>();
        }
        
        static ref create(bool invisible) {
            return boost::make_shared<InvisiblePresence>(invisible);
        }
        
        static ref create(InvisiblePresence::ref presence) {
            return boost::make_shared<InvisiblePresence>(*presence);
        }
        
        bool getInvisible() const { return invisible_; }
        void setInvisible(bool invisible) { invisible_ = invisible; }
        
        boost::shared_ptr<InvisiblePresence> clone() const {
            return boost::make_shared<InvisiblePresence>(*this);
        }
    
    private:
        bool invisible_;
    };
}
