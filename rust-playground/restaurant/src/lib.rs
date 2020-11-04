mod front_of_house {
    pub enum Employee {
        Hostess,
        Server,
        Waiter,
        BusBoy,
    }

    mod hosting {
        fn add_to_waitlist() {}
        fn seat_at_table() {}
    }

    mod serving {
        fn take_order() {}
        fn serve_order() {}
        fn take_payment() {}
    }
}
