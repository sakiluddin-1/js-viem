import {createWalletClient, custom, createPublicClient, parseEther, defineChain, formatEther} from "https://esm.sh/viem";
import "https://esm.sh/viem/window";
import {contractAddress, abi} from "./constants-js.js";

let connectButton = document.getElementById("connectButton");
let fundButton = document.getElementById("fundButton");
let ethAmountInput = document.getElementById("ethAmount");
let inputEthValue = document.getElementById("ethAmount");
let getBalance = document.getElementById("getBalance");

let walletClient;
let publicClient;
let currentChain;

async function connect() {
    if(typeof window.ethereum !== "undefined") {
        walletClient = createWalletClient({
            transport: custom(window.ethereum)
        });

        const accounts = await walletClient.requestAddresses();

        connectButton.innerHTML = "Connected";

        console.log(accounts)
    }
    else {
        connectButton.innerHTML = "Please install metamask";
    }
}

async function fund() {
    let ethValue = inputEthValue.value;
    try {
        const ethAmount = ethAmountInput.value;
        if(typeof window.ethereum !== "undefined") {
            walletClient = createWalletClient({
                transport: custom(window.ethereum)
            })

            const account = await walletClient.requestAddresses();
            currentChain = await getCurrentChain(walletClient);

            publicClient = createPublicClient({
                transport: custom(window.ethereum)
            })

            const {request} = await publicClient.simulateContract({
                address: contractAddress,
                abi,
                functionName: "fund",
                chain: currentChain,
                account: account,
                value: parseEther(ethValue),
            })

            const hash = await walletClient.writeContract(request);

            console.log(hash);
        }
    } catch(error) {
        console.log(error);
}
}

async function getCurrentChain(client) {
    let chainId = await client.getChainId();
    let currentChain = defineChain({
        id: chainId,
        name: "Custom Chain Name",
        nativeCurrency: {
            name: "Ether",
            symbol: "ETH",
            decimals: 18,
        },
        rpcUrls: {
            default: {
                http: ["http://localhost:8545"],
            },
        },
    })

    return currentChain;
}

async function getContractBalance() {
    if(typeof window.ethereum !== "undefined") {
       publicClient = createPublicClient({
        transport: custom(window.ethereum)
       });

       const balance = await publicClient.getBalance({
        address: contractAddress,
       });
       console.log(formatEther(balance));
    }
}

connectButton.onclick = connect
fundButton.onclick = fund
getBalance.onclick = getContractBalance