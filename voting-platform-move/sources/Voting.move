module my_addrx::VotingContract {
    use std::table;

    struct Proposal {
        votes_for: u64,
        votes_against: u64,
    }

    /// Table to store multiple proposals by ID.
    struct VotingState has key {
        proposals: table::Table<u64, Proposal>,
    }

    /// Initialize a voting state.
    public fun initialize_voting_state(account: &signer) {
        let proposals = table::new<u64, Proposal>(account);
        move_to(account, VotingState { proposals });
    }

    /// Create a new proposal with a unique ID.
    public fun create_proposal(voting_state: &mut VotingState, proposal_id: u64) {
        let proposal = Proposal { votes_for: 0, votes_against: 0 };
        table::add(&mut voting_state.proposals, proposal_id, proposal);
    }

    /// Vote in favor of a proposal by ID.
    public fun vote_for(voting_state: &mut VotingState, proposal_id: u64) {
        let proposal = table::borrow_mut(&mut voting_state.proposals, proposal_id);
        proposal.votes_for = proposal.votes_for + 1;
    }

    /// Vote against a proposal by ID.
    public fun vote_against(voting_state: &mut VotingState, proposal_id: u64) {
        let proposal = table::borrow_mut(&mut voting_state.proposals, proposal_id);
        proposal.votes_against = proposal.votes_against + 1;
    }

    /// Retrieve the total votes for a proposal.
    public fun get_votes(voting_state: &VotingState, proposal_id: u64): (u64, u64) {
        let proposal = table::borrow(&voting_state.proposals, proposal_id);
        (proposal.votes_for, proposal.votes_against)
    }
}
