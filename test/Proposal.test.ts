import { expect } from "chai";
import { ethers } from "hardhat";
import { Proposal } from "../typechain-types";



describe("Proposal contract", function () {
  let proposal: Proposal;
  beforeEach(async function () {
    const Proposal = await ethers.getContractFactory("Proposal");
    proposal = await Proposal.deploy();
  });

  it("should deploy the contract", async function () {
    const address = await proposal.getAddress();
    expect(address).to.properAddress;
  });

  it("should create a new proposal", async function () {
    await proposal.createProposal( "Proposal Description");
    const prop = await proposal.getProposal(1);
    expect(prop[0]).to.equal(1);
    expect(prop[1]).to.equal("Proposal Description");
  });

  it("should get a proposal by id", async function () {
    await proposal.createProposal("Proposal Description");
    const prop = await proposal.getProposal(1);
    expect(prop[0]).to.equal(1);
    expect(prop[1]).to.equal("Proposal Description");
  });

  it("should allow voting on a proposal", async function () {
    await proposal.createProposal("Proposal Description");
    await proposal.vote(1);
    const prop = await proposal.getProposal(1);
    expect(prop[2]).to.equal(1);
  });

  it("should get the correct vote counts", async function () {
    await proposal.createProposal("Proposal Description");
    await proposal.vote(1);
    const prop = await proposal.getProposal(1);
    expect(prop[2]).to.equal(1);
  });
});