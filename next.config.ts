/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  // Disable source maps in production for smaller bundle size
  productionBrowserSourceMaps: false,
  // Enable compression
  compress: true,
  // Optimize images
  images: {
    unoptimized: false,
  },
  // Optional: Add any other configurations you need
}

module.exports = nextConfig
