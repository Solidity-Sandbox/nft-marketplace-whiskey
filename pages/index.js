import Head from 'next/head'
import Image from 'next/image'
import styles from '../styles/Home.module.css'

export default function Home() {
  return (
    <div>
      <Head>
        <title>Whiskey Marketplace</title>
        <meta name="description" content="Whiskey Marketplace Home" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      Welcome to the Whiskey Market!!
    </div>
  )
}
