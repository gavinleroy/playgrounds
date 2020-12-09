use std::thread;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::Arc;

fn main() {
    let data = vec![1, 2, 3, 4];
    // Arc so that the memory the AtomicUsize is stored in still exists for
    // the other thread to increment, even if we completely finish executing
    // before it. Rust won't compile the program without it, because of the
    // lifetime requirements of thread::spawn!
    let idx = Arc::new(AtomicUsize::new(0));
    let other_idx = idx.clone();

    // `move` captures other_idx by-value, moving it into this thread
    thread::spawn(move || {
        // It's ok to mutate idx because this value
        // is an atomic, so it can't cause a Data Race.
        other_idx.fetch_add(10, Ordering::SeqCst);
    });

    // Index with the value loaded from the atomic. This is safe because we
    // read the atomic memory only once, and then pass a copy of that value
    // to the Vec's indexing implementation. This indexing will be correctly
    // bounds checked, and there's no chance of the value getting changed
    // in the middle. However our program may panic if the thread we spawned
    // managed to increment before this ran. A race condition because correct
    // program execution (panicking is rarely correct) depends on order of
    // thread execution.
    println!("{}", data[idx.load(Ordering::SeqCst)]);
}


//use log::debug;
//use simplelog::{ConfigBuilder, LevelFilter, SimpleLogger};
//use futures::future;
//use std::future::Future;
//
//async fn async_hello() {
//    debug!("Hello, asynchronously!");
//}
//
//async fn async_value() -> i32 {
//    42
//}
//
//#[tokio::main]
//async fn main() {
//    
//}
//
//fn main() {
//
//    let config = ConfigBuilder::new()
//            .set_target_level(LevelFilter::Trace)
//            .build();
//    let _ = SimpleLogger::init(LevelFilter::Debug, config);
//
//    let mut rt = tokio::runtime::Runtime::new().unwrap();
//    rt.block_on(async_hello());
//
////
////    let mut rt = tokio::runtime::Builder::new()
////        .threaded_scheduler()
////        .core_threads(4)
////        .on_thread_start(|| debug!("on_thread_start()"))
////        .build()
////        .unwrap();
////
////    rt.enter(|| {
////        debug!("in rt.enter()");
////        tokio::spawn(future::lazy(|_| debug!("in tokio::spawn()")));
////    });
////    
////    rt.spawn(future::lazy(|_| debug!("in rt.spawn()")));
////    rt.block_on(future::lazy(|_| debug!("in rt.block_on()")));
////
////    future::ready(42);
//
////    let mut rt = tokio::runtime::Runtime::new().unwrap();
////    rt.enter(|| {
////        println!("in rt.enter()");
////        tokio::spawn(future::lazy(|_| println!("in tokio::spawn()")));
////    });
////    // tokio::spawn(future::lazy(|_| println!("Hello from spawn")));
////    
////    rt.spawn(future::lazy(|_| println!("in rt.spawn()")));
////    rt.block_on(future::lazy(|_| println!("in rt.block_on()")));
//}
