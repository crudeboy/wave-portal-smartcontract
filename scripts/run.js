const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners()
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal')
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther('0.1'),
  })
  await waveContract.deployed()
  console.log('Contract addy:', waveContract.address)

  console.log('Contract deployed to:', waveContract.address)
  console.log('Contract deployed by:', owner.address)

  /*
   * Get Contract balance
   */
  let contractBalance = await hre.ethers.provider.getBalance(waveContract.address)
  console.log('Contract balance:', hre.ethers.utils.formatEther(contractBalance))

  let waveCount
  waveCount = await waveContract.getTotalWaves()
  console.log(waveCount.toNumber())

  //wave to the address
  let waveTxn = await waveContract.wave(waveContract.address, 'Owo mejii loke')
  await waveTxn.wait()

  console.log(randomPerson, 'randomPerson')
  waveTxn = await waveContract.connect(randomPerson).wave(randomPerson.address, 'Another message!')
  await waveTxn.wait() // Wait for the transaction to be mined

  waveCount = await waveContract.getTotalWaves()

  waveTxn = await waveContract.connect(randomPerson).wave(randomPerson.address, 'i dey for u die')
  await waveTxn.wait()

  waveTxn = await waveContract.getNumberOfWavesByGee(randomPerson.address)

  waveCount = await waveContract.getTotalWaves()

  /*
   * Get Contract balance to see what happened!
   */
  contractBalance = await hre.ethers.provider.getBalance(waveContract.address)
  console.log('Contract balance:', hre.ethers.utils.formatEther(contractBalance))

  let allWaves = await waveContract.getAllWaves()
  console.log(allWaves)
}

const runMain = async () => {
  try {
    await main()
    process.exit(0) // exit Node process without error
  } catch (error) {
    console.log(error)
    process.exit(1) // exit Node process while indicating 'Uncaught Fatal Exception' error
  }
  // Read more about Node exit ('process.exit(num)') status codes here: https://stackoverflow.com/a/47163396/7974948
}

runMain()
