module MyModule::CharityDonation {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing the donation system.
    struct Charity has store, key {
        total_donated: u64,
    }

    /// Function to create a charity donation account.
    public fun create_charity(owner: &signer) {
        move_to(owner, Charity {
            total_donated: 0,
        });
    }

    /// Function to automatically donate to a charity.
    public fun donate(sender: &signer, charity_addr: address, amount: u64) acquires Charity {
        let charity = borrow_global_mut<Charity>(charity_addr);

        // Transfer tokens from sender to charity
        let donation = coin::withdraw<AptosCoin>(sender, amount);
        coin::deposit<AptosCoin>(charity_addr, donation);

        // Update total donations
        charity.total_donated = charity.total_donated + amount;
    }
}
