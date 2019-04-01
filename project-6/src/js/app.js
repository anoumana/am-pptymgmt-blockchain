
App = {
    web3Provider: null,
    contracts: {},
    emptyAddress: "0x0000000000000000000000000000000000000000",
    rentalID: 0,
    rentalName: null,
    rentalAddress: null,
    rentalNotes: null,
    rentalPricePerDay: 0,
    metamaskAccountID: "0x0000000000000000000000000000000000000000",
    contractOwnerID: "0x0000000000000000000000000000000000000000",
    rentalOwnerID: "0x0000000000000000000000000000000000000000",
    pptyMgrID: "0x0000000000000000000000000000000000000000",
    cleaningCmpID: "0x0000000000000000000000000000000000000000",
    renterID: "0x0000000000000000000000000000000000000000",

 
    init: async function () {
        App.readForm();
        /// Setup access to blockchain
        return await App.initWeb3();
    },

    readForm: function () {
        App.rentalID = $("#rentalID").val();
        App.rentalName = $("#rentalName").val();
        App.rentalAddress = $("#rentalAddress").val();
        App.rentalNotes = $("#rentalNotes").val();
        App.rentalPricePerDay = $("#rentalPricePerDay").val();
        App.renterID = $("#renterID").val();
        App.pptyMgrID = $("#pptyMgrID").val();
        App.cleaningCmpID = $("#cleaningCmpID").val();
        App.rentalDays = $("#rentalDays").val();


        console.log(
            App.rentalID,
            App.rentalName,
            App.rentalAddress, 
            App.rentalNotes, 
            App.rentalPricePerDay, 
            App.renterID, 
            App.pptyMgrID, 
            App.cleaningCmpID,
            App.rentalDays
        );
    },

    initWeb3: async function () {
        /// Find or Inject Web3 Provider
        /// Modern dapp browsers...
        if (window.ethereum) {
            App.web3Provider = window.ethereum;
            try {
                // Request account access
                await window.ethereum.enable();
            } catch (error) {
                // User denied account access...
                console.error("User denied account access")
            }
        }
        // Legacy dapp browsers...
        else if (window.web3) {
            App.web3Provider = window.web3.currentProvider;
        }
        // If no injected web3 instance is detected, fall back to Ganache
        else {
            App.web3Provider = new Web3.providers.HttpProvider('http://localhost:9545');
        }

        App.getMetaskAccountID();

        return App.initSupplyChain();
    },

    getMetaskAccountID: function () {
        web3 = new Web3(App.web3Provider);

        // Retrieving accounts
        web3.eth.getAccounts(function(err, res) {
            if (err) {
                console.log('Error:',err);
                return;
            }
            console.log('getMetaskID:',res);
            App.metamaskAccountID = res[0];

        })
    },

    initSupplyChain: function () {
        /// Source the truffle compiled smart contracts
        var jsonSupplyChain='../../build/contracts/SupplyChain.json';
        
        /// JSONfy the smart contracts
        $.getJSON(jsonSupplyChain, function(data) {
            console.log('data',data);
            var SupplyChainArtifact = data;
            App.contracts.SupplyChain = TruffleContract(SupplyChainArtifact);
            App.contracts.SupplyChain.setProvider(App.web3Provider);
            
        });

        return App.bindEvents();
    },

    bindEvents: function() {
        $(document).on('click', App.handleButtonClick);
    },

    
    handleButtonClick: async function(event) {
        event.preventDefault();

        App.getMetaskAccountID();

        var processId = parseInt($(event.target).data('id'));
        console.log('processId',processId);

        switch(processId) {
            case 1:
                return await App.subscribe(event);
                break;
            case 2:
                return await App.registerRental(event);
                break;
            case 3:
                return await App.bookRental(event);
                break;
            case 4:
                return await App.getRentalPptyInfo(event);
                break;
            case 5:
                return await App.scheduleCleaning(event);
                break;
            case 6:
                return await App.cleaningDone(event);
                break;
            case 7:
                return await App.checkIn(event);
                break;
            case 8:
                return await App.checkOut(event);
                break;
            }
    },

    subscribe: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.subscribe(
                App.rentalName, 
                App.pptyMgrID, 
                App.cleaningCmpID, 
                {from: App.metamaskAccountID, value: 1000}
            );
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('subscribe :',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    registerRental: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.registerRental(
                App.rentalID,
                App.rentalAddress, 
                App.rentalNotes, 
                App.rentalPricePerDay
            );
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('registerRental :',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    getRentalPptyInfo: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        const rentalPptyInfo = document.getElementById("rentalPptyInfo");

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.getRentalPptyInfo(
                App.rentalID
            );
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('getRentalPptyInfo :',result);
            rentalPptyInfo.innerHTML = result;
        
        }).catch(function(err) {
            console.log(err.message);
            rentalPptyInfo.innerHTML = err.message;
        });
    },

    bookRental: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        const rentalPptyInfo = document.getElementById("rentalPptyInfo");

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.bookRental(
                App.rentalID,
                App.rentalDays, 
                {from: App.metamaskAccountID, value: 1000}
            );
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('bookRental :',result);
            rentalPptyInfo.innerHTML = result;
        
        }).catch(function(err) {
            console.log(err.message);
            rentalPptyInfo.innerHTML = err.message;
        });
    },

    scheduleCleaning: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        const rentalPptyInfo = document.getElementById("rentalPptyInfo");

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.scheduleAppointment(
                App.rentalID
            );
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('scheduleCleaning :',result);
            rentalPptyInfo.innerHTML = result;
        
        }).catch(function(err) {
            console.log(err.message);
            rentalPptyInfo.innerHTML = err.message;
        });
    },

    cleaningDone: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        const rentalPptyInfo = document.getElementById("rentalPptyInfo");

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.cleanRental(
                App.rentalID
            );
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('cleanRental :',result);
            rentalPptyInfo.innerHTML = result;
        
        }).catch(function(err) {
            console.log(err.message);
            rentalPptyInfo.innerHTML = err.message;
        });
    },

    checkIn: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        const rentalPptyInfo = document.getElementById("rentalPptyInfo");

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.checkIn(
                App.rentalID
            );
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('checkIn :',result);
            rentalPptyInfo.innerHTML = result;
        
        }).catch(function(err) {
            console.log(err.message);
            rentalPptyInfo.innerHTML = err.message;
        });
    },

    checkOut: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        const rentalPptyInfo = document.getElementById("rentalPptyInfo");

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.checkOut(
                App.rentalID
            );
        }).then(function(result) {
            $("#ftc-item").text(result);
            console.log('checkOut :',result);
            rentalPptyInfo.innerHTML = result;
        
        }).catch(function(err) {
            console.log(err.message);
            rentalPptyInfo.innerHTML = err.message;
        });
    },


 };

$(function () {
    $(window).load(function () {
        App.init();
    });
});
