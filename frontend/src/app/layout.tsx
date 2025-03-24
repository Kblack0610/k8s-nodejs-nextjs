import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Kubernetes NextJS + NodeJS Demo',
  description: 'A demo application with NextJS frontend and NodeJS backend running on Kubernetes',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
