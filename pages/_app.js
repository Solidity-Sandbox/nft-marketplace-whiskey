import '../styles/globals.css'
import Link from 'next/link'

function whiskeyMarketplace({ Component, pageProps }) {
  return (
    <div>
      <nav className="border-p p-6" style={{ backgroundColor: 'brown' }}>
        <p className="text-4x1 font-bold text-white">WhiskeyMarketplace</p>
        <div className='flex mt-4 justify-center'>
          <Link href='/'>
            <a className='mr-40'>Main Marketplace</a>
          </Link>
          <Link href='/mint-item'>
            <a className='mr-40'>Mint Item</a>
          </Link>
          <Link href='/my-nfts'>
            <a className='mr-40'>My NFTs</a>
          </Link>
          <Link href='/account'>
            <a className='mr-40'>My Account</a>
          </Link>
        </div>
      </nav>
      <Component {...pageProps} />
    </div>
  )
}

export default whiskeyMarketplace
