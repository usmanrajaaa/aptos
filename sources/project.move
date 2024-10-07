module MyModule::PredictionMarket {

    use aptos_framework::signer;
    use std::vector;

    /// Struct representing a prediction event.
    struct PredictionEvent has store, key {
        yes_pool: u64,         // Total tokens bet on "Yes"
        no_pool: u64,          // Total tokens bet on "No"
        is_resolved: bool,     // Whether the event outcome has been resolved
        outcome: bool,         // Outcome of the event (true = "Yes", false = "No")
    }

    /// Struct representing user bets on a specific event.
    struct UserBet has store, key {
        amount: u64,           // Amount of tokens bet by the user
        prediction: bool,      // User's prediction (true = "Yes", false = "No")
    }

    /// Function to create a new prediction event.
    public fun create_event(creator: &signer) {
        let event = PredictionEvent {
            yes_pool: 0,
            no_pool: 0,
            is_resolved: false, // Initially not resolved
            outcome: false,     // Default value, irrelevant until resolved
        };
        move_to(creator, event);
    }

    /// Function to place a bet on a prediction event.
    public fun place_bet(bettor: &signer, creator_address: address, amount: u64, prediction: bool) acquires PredictionEvent {
        let event = borrow_global_mut<PredictionEvent>(creator_address);

        // Ensure the event is not already resolved
        assert!(!event.is_resolved, 1);

        // Record the user's bet
        if (prediction) {
            event.yes_pool = event.yes_pool + amount;
        } else {
            event.no_pool = event.no_pool + amount;
        };

        // Create a user bet struct
        let user_bet = UserBet {
            amount,
            prediction,
        };
        move_to(bettor, user_bet);
    }
}
