import { combineReducers } from 'redux';

import { usersReducer } from './entities/users_reducer';
import { photosReducer } from './entities/photos_reducer';
import { followsReducer } from './entities/follows_reducer';

const entitiesReducer = combineReducers({
    users: usersReducer,
    photos: photosReducer,
    follows: followsReducer
});

export default entitiesReducer;