# CashVit - Expense Tracker Mobile App 💰

![Flutter](https://img.shields.io/badge/Flutter-3.35.5-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)
![Riverpod](https://img.shields.io/badge/State-Riverpod-blueviolet)
![Architecture](https://img.shields.io/badge/Architecture-Clean-green)

Aplikasi mobile sederhana namun modern untuk melacak pengeluaran dan pemasukan, dibangun dengan **Flutter** dan menerapkan **Clean Architecture**. Proyek ini dibuat sebagai studi kasus untuk demonstrate kemampuan pengembangan aplikasi mobile yang *scalable*, terstruktur, dan bersih.

---

## 📋 Case Study Requirements Fulfillment

Proyek ini telah memenuhi seluruh persyaratan studi kasus yang diberikan:

| Requirement | Status | Implementation Details |
|-------------|--------|------------------------|
| **Expense & Income Tracking** | ✅ Done | Fitur CRUD lengkap untuk transaksi pengeluaran dan pemasukan. |
| **Standard Flutter Widgets** | ✅ Done | UI dibangun menggunakan widget native Material Design dengan kustomisasi tema. |
| **Animations** | ✅ Done | Menggunakan Hero animations, implicit animations, dan transisi halaman standar Flutter. |
| **State Management** | ✅ Done | Menggunakan **Flutter Riverpod** untuk manajemen state yang reaktif dan aman. |
| **Public API Integration** | ✅ Done | Integrasi dengan **FakeStore API** (POST login, GET user data). |
| **Minimum 2 Pages** | ✅ Done | Terdiri dari Login, Dashboard, Add Transaction, dan Profile screens. |
| **Clean Code & Structure** | ✅ Done | Menerapkan prinsip **Clean Architecture** (Data, Domain, Presentation layers). |
| **Documentation** | ✅ Done | Dokumentasi lengkap tersedia di folder `docs/` dan README ini. |

---

## 🛠 Tech Stack & Environment

Aplikasi ini dikembangkan dan diuji menggunakan konfigurasi lingkungan berikut:

- **Flutter SDK**: `3.35.5`
- **Dart SDK**: `3.x`
- **Java JDK**: `18.0.2.1`
- **Gradle**: `8.13`
- **State Management**: `flutter_riverpod`
- **Network Client**: `dio`
- **Code Generation**: `freezed`, `json_serializable`

---

## 🏛 Architecture & Code Structure

Proyek ini mengikuti prinsip **Clean Architecture** untuk memastikan pemisahan *concerns* yang jelas, kemampuan testing (testability), dan kemudahan pemeliharaan (maintainability).

### High-Level Layers

1.  **Domain Layer (Core Business Logic)**
    - Layer terdalam yang tidak memiliki dependensi ke layer lain.
    - Berisi `Entities` (blueprint objek bisnis), `Repositories` (interface kontrak), dan `UseCases` (logika bisnis spesifik).
2.  **Data Layer (Implementation Details)**
    - Implementasi teknis dari kontrak domain.
    - Berisi `Models` (DTOs untuk parsing JSON), `DataSources` (akses API remote/local), dan `Repository Implementations`.
3.  **Presentation Layer (UI & State)**
    - Layer terluar yang berinteraksi dengan pengguna.
    - Berisi `Screens`, `Widgets`, dan `Providers` (State Management Logic).

### Folder Structure Overview

```bash
lib/
├── core/                       # Infrastruktur & utilitas bersama
│   ├── constants/              # Konfigurasi API & aplikasi
│   ├── services/               # Services global (Dio Client, dll)
│   ├── themes/                 # Design System (Colors, Typography)
│   └── utils/                  # Utility functions (Currency Formatting)
│
├── features/                   # Modul Fitur (Feature-first)
│   ├── auth/                   # Fitur Autentikasi
│   │   ├── data/               # Impl: Models, Datasources, Repo Impl
│   │   ├── domain/             # Logic: Entities, UseCases, Repos Interface
│   │   └── presentation/       # UI: Screens, Providers, Widgets
│   │
│   ├── home_dashboard/         # Fitur Halaman Utama
│   ├── add_transaction/        # Fitur Tambah Transaksi
│   ├── profile/                # Fitur Profil User
│   └── ...
│
└── shared/                     # Komponen UI yang digunakan ulang
    ├── extensions/             # Dart Extensions
    └── widgets/                # Reusable Widgets
```

---

## 🔌 API Integration

Aplikasi ini terhubung dengan **FakeStore API** (`https://fakestoreapi.com`) untuk demonstrasi integrasi HTTP Request (GET & POST).

| Method | Endpoint | Description | Implementation File |
|--------|----------|-------------|---------------------|
| **POST** | `/auth/login` | Melakukan autentikasi user dan mendapatkan token. | `lib/features/auth/data/datasources/auth_remote_datasource.dart` |
| **GET** | `/users/{id}` | Mengambil detail profil user setelah login berhasil. | `lib/features/profile/data/datasources/profile_remote_datasource.dart` |

---

## ✨ Key Features

### 1. Authentication Flow
- Validasi input form yang real-time.
- Penanganan state loading dan error handling (misal: koneksi gagal).
- Fitur login simulasi menggunakan kredensial dummy dari API.

### 2. Dashboard & Tracking
- **Balance Card**: Menampilkan total saldo, pemasukan, dan pengeluaran secara visual.
- **Transaction List**: Daftar riwayat transaksi dengan format mata uang Rupiah (IDR).
- **Filtering**: (Future) Filter transaksi berdasarkan kategori atau tipe.

### 3. Add Expense/Income
- Form input interaktif dengan validasi.
- Pemilihan kategori dan tipe transaksi (Pemasukan/Pengeluaran).
- Date picker untuk memilih tanggal transaksi.

### 4. User Profile
- Menampilkan data diri user yang diambil dari API.
- Tombol logout untuk menghapus sesi (simulasi).

---

## 🚀 How to Run

1.  **Clone Repository**
    ```bash
    git clone https://github.com/username/cash_vit.git
    cd cash_vit
    ```

2.  **Install Dependencies**
    Pastikan Flutter SDK terinstal, lalu jalankan:
    ```bash
    flutter pub get
    ```

3.  **Code Generation (Optional)**
    Jika Anda memodifikasi model atau provider, jalankan build runner:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Run Application**
    ```bash
    flutter run
    ```

---

## 📄 Documentation

Dokumentasi detail mengenai pengembangan proyek ini dapat ditemukan di folder `docs/`:

- [**Technical Overview**](docs/TECHNICAL_OVERVIEW.md): Penjelasan mendalam tentang arsitektur dan state management.
- [**Clean Architecture Workflow**](docs/CLEAN_ARCHITECTURE_WORKFLOW.md): Panduan langkah demi langkah pengembangan fitur baru.
- [**Design System**](docs/DESIGN_SYSTEMS.md): Standar desain UI/UX yang digunakan.
- [**PRD**](docs/PRD.md): Dokumen Kebutuhan Produk (Product Requirements Document).

---

**Developed with ❤️ using Flutter.**
