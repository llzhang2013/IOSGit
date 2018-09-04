
let store={state:1,dispatch:2}
let dispatch = 3;
let dd2 = Object.assign({}, store, { dispatch })
console.log('dd2 -------------:', dd2);
//dd2 -------------: { state: 1, dispatch: 3 }


const logger = store => next => {
return action => {
    console.log('logger-dispatching', action)
    let result = next(action)//dispatch(action);
    console.log('logger-next state', store.state)
    console.log('result :', result);//result : undefined
    return result
  }
}

function applyMiddleware(store, middlewares) {
    middlewares = middlewares.slice()
    middlewares.reverse()
  
    let dispatch = store.dispatch
    middlewares.forEach(middleware =>
      dispatch = middleware(store)(dispatch)
    )
  let newState = Object.assign({}, store, { dispatch })
  console.log('newState :', newState);
  //newState : { state: { message: '哈哈' }, dispatch: [Function] }
    return newState
  }

   store ={
      state:{message:'哈哈'},
      dispatch:(action)=>{
        console.log('执行action :', action);
      }

  }
  store =applyMiddleware(store,[logger]);

  let action ={
      type:'吃饭'
  }

  store.dispatch(action);

//   logger-dispatching { type: '吃饭' }
//   执行action : { type: '吃饭' }
//   logger-next state { message: '哈哈' }
