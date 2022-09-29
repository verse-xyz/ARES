# ARES, created by Verse

ARES (Autonomous Reactive Emissions System) is a hyperimage protocol by Verse. Because a new internet needs new mediums.

# TLDR?

Hyperimage = [ image ] + [ market ] + [ network ]

Ares rethinks the concept of an "image" from first principles, creating a new internet-native and crypto-native medium for images that are more than just static files. In a new internet powered by crypto rails, images are a substrate for memetic coordination. If the web1-web2 era was defined by images that were static, 2D files, Verse believes the next era of the internet will be defined by the hyperimage: an image that is a digital object with a self-contained state, market, and social network programmed into the image itself.

Images = Static, single-player, all value is created by external experiences.

Hyperimages = Dynamic, multiplayer, value accrues to the image by virtue of its internally programmed mechanisms.

The image is the market is the social network.

# Why?

Let's consider how images exist on the internet today. On the modern internet, most images are just static files hosted on some centralized servers. We create and freely distribute these images on large networks like Instagram, YouTube, and Twitter. The problem is that these images have no interally programmed mechanisms to accrue value. Intuitively, it makes sense that an image becomes more valuable as a function of the attention it generates within a demand-constrained attention economy. The more people look at, share, or curate an image, the more valuable it becomes. However, all of these social mechanisms are monopolized by centralized platforms that rent-seek these behaviors and extract much of the value for themselves.

It's imperative to create a new medium for digital images that is decentralized, where value natively accrues to creators and curators as a result of self-sustaining network effects.

# Where do NFTs come into play?

Current NFT structures have started to solve the problem of native value generation for digital images, but are underdeveloped. Today, the majority of the NFT space looks like this: you mint an NFT, and that's it. The NFT is still a static object; All the subsequent curation, economic activity, cultural remixing, and community interaction happens externally to the NFT (in a token-gated discord, on Twitter, etc). 

But what if we actually program the social behaviors & interaction modalities into the NFT itself? Then, we’re operating on a whole new premise that is inherently more interactive and powerful. Images are no longer static files, they're living, breathing objects, informational currencies.

# So how does Ares work?

The Ares protocol is a new medium for internet-native images: hyperimages. Hyperimages can be analogized as collectively-created albums; they're images with a self-contained state, market, and social network programmed into the image itself. 

Through the protocol, a creator deploys a hyperimage NFT contract with a name and founding image that sets the theme of the network. The creator also sets the rate at which they want the network to grow (ex: "I want 5 NFTs to be minted from this contract per day at a target price of 1 ETH"). Anyone can then mint a new NFT from this contract. Here's where it gets interesting. At mint time, the minter uploads a new imageURI for the NFT that they mint. The minter is incentivized to add a high quality contribution to the network to drive more attention to the network and draw in subsequent participants. As the attention and cultural relevance around the network grows, demand increases for people to get their creations included in the network. This creates a virtuous cycle of attention and value accrual. The sole purpose of the hyperimage network is to attract attention to itself - similar to any NFT collection. However, the powerful feature here is that the only way to drive value is by adding better content to the network over time. There’s literally only one way to add value to the network, and this constraint serves as a native social interaction that is programmed into the NFT itself.

So if I own an NFT from this contract, my NFT's tokenURI will be an image that I contributed to the network (or it might be someone else's tokenURI that I chose to "mirror", but more on that later). So now, I own an image that has an internal state, a market value, and is networked to other images that were created by other people who minted from the contract. 

The internal market will dynamically increase the price to add to the network as demand increases, and lower the price as demand decreases. At any time, I can burn my NFT to get ETH in return. However, doing so removes my image from the network. So you have to ask yourself how much you value your image being part of the network.

# Let's look at an example!

Let's say that my friend Jacob deployed a hyperimage contract titled "Zorbs" with the founding image being a plain zorb. I see this zorb, and have a zorb-ish picture of my own that I want to add to this network. So I mint an NFT from the contract and upload my image. Then, other people see this Zorb meme becoming more popular, and they want to add their own Zorb-inspired images to be part of the network. All of a sudden, we have this collectively-created network of Zorb images where participants are incentivized to keep the meme relevant and growing faster than they're being diluted by the linearly increasing emissions rate. We've created a type of informational currency; a self-sustaining meme economy around the zorb image.

# Mechanisms!
Ares relies on a few fundamental mechanisms to create hyperimages with an internal state, market, and social network.

## State & Social Network
The bread and butter of a hyperimage contract is the ability for individuals to create/add their own images to the network. The verb we use to describe this behavior is "Knit" - analogous to multiple strands of fabric being knitted together to form a cohesive whole. Anyone can call the `knit` function on the contract - this is the primary "create" behavior.

In any network of images, curation is paramount. It would be impossible to have a self-sustaining memetic economy without a way to curate the best creations. Additionally, individuals shouldn't be forced to add something new just to get exposure/participate in the network. This is why the `mirror` function exists. Instead of knitting a new image to the network, I can choose to "mirror" an existing image. Thus, when I mint a new NFT from the contract, my tokenURI will mirror another tokenURI of an existing NFT that I really like. This function creates a native curation system and social behavior within the network, since the best images will be mirrored the most as people want to own them. In web2 terms, you could analogize this behavior as "liking" or "reposting" an image.

## Market
When a creator initially deploys the hyperimage contract, they define a target price and growth rate for the network. For example, in the Zorb example above, the creator might set the target price to 1 ETH and the growth rate to 5 NFTs per day. This means that the creator wants the network to grow at a rate of 5 NFTs per day, and that each NFT should be priced at 1 ETH. The creator can change these parameters at any time, and the contract will dynamically adjust the price to mint a new NFT to match the target price.

The Ares protocol reimagines images as internet-native objects. The protocol provides all the infrastructure for digital images to be memetic building blocks that incentivize coordinated creation, curation, and distribution for a new internet powered by crypto rails. We've seen these behaviors already in internet structures like subreddits, hashtags, micronetworks, and meme pages. But we've never seen formal infrastructure designed to weave these behaviors into the fabric of the media itself. When you look at a hyperimage you own in your wallet, you're not just looking at a static image that you own. You're looking at a constantly evolving, dynamic network. You can see the value of the image you own in the context of the network it's a part of. You can see all the other images it's linked to. You can see the meme grow in real time.




# Hyperobject Pair

The cornerstone of the protocol is the `PairFactory` contract. The `PairFactory` is a factory contract which handles deployment of hyperobject pairs as minimal clone proxies delegating functionality to corresponding logic contracts. Each pair consists of a `Hyperobject` contract (an ERC-721 NFT contract) and an `Exchange` contract (an ERC-20 contract). The `create` function deploys a new pair.

# Hyperobject Contract

Each `Hyperobject` contract deployed is an ERC-721 contract. The `tokenURI`s for each NFT minted through this contract are identical and are set to the `baseURI` passed at construction. Minting functionality of NFTs is managed exclusively by the paired `Exchange` contract.

# Exchange Contract
Each `Exchange` contract deployed is an ERC-20 contract. This contract has a built-in autonomous exchange governing the price and supply of the underlying token through the use of a bonding curve. Anyone can buy and sell tokens from this contract with instant liquidity, meaning that the contract will mint and burn tokens on-demand, respectively. The bonding curve is based on a power function, and so the price of the token increases as supply increases, and the price decreases as supply decreases.

Anyone who owns >= 1 atomic token for this contract can call the `redeem` function. This function makes a call to the paired ERC-721 contract. Upon the token owner calling this function, the contract transfers 1 token from the caller to the paired ERC-721 contract. In exchange, the ERC-721 contract mints and transfers an NFT to the caller. In effect, the redeemed ERC-20 token is now locked in the ERC-721 contract. This has the effect of maintaining some base price level for the NFT, as the redeemed token can never be burned and subsequently decrease the token's price. 

Additionally, upon deployment, the pair creator can specify a `CreatorShare`. The `CreatorShare` represents a royalty fee on each transaction that occurs through the contract. By specifying a share percentage, the creator can be perpetually compensated for trades that happen with the token. 

# Summary + Vision
This new exchange structure produces numerous benefits for both creators and consumers.

**Consumers** now have instant liquidity to buy and sell continuous quantities of the NFT. Those individuals who may have been priced out of participating in a fixed-price NFT can now buy fractions of the underlying ERC-20, while whales can still scoop up larger quantities. Thus, the mechanism enables exchanging all along the price curve and maximizes efficiency in the market.

Additionally, **creators** have complete control in determining how their NFT is priced throughout its lifecycle. The creator can specify the underlying reserve ratio and initial slope of the ERC-20 price curve, fine-tuning how they want their object to be priced as demand rises and falls. In this way, creators can set a practical limit on the NFT’s supply and enforce a level of scarcity.

Perhaps most importantly, Verse enables digital objects to live autonomously, anywhere on the internet, without ever needing to link out to a marketplace. Imagine scrolling on a website, seeing a Verse-created NFT, and being able to exchange it right then and there. It’s like if you were walking down the street, saw a pair of Nike Dunks, and could snap your fingers to put a pair on your feet - rather than having to track down the lowest price, go to the store, and then buy them. Thus, the protocol catalyzes new forms of discovery with the ability for objects to be exchanged where they are consumed.

The scope of digital objects is impossible to comprehend, but one thing is certain. They will fundamentally transform the construction of the internet, affecting our relationships with media, culture, digital infrastructure, identity, and more. **Verse is a hyperexchange: a hyperstructure enabling the autonomous exchange of digital objects and creating a composable, infinite internet.**

