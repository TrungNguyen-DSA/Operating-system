#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <string.h>

int main() {
    size_t size = 4096; // Kích thước của 1 Page tiêu chuẩn trên x86

    // 1. Cấp phát vùng nhớ ảo giống một trang hệ thống (Quyền Đọc & Ghi ban đầu)
    char *mem = mmap(NULL, size,
                     PROT_READ | PROT_WRITE,
                     MAP_PRIVATE | MAP_ANONYMOUS,
                     -1, 0);
                     
    if (mem == MAP_FAILED) {
        perror("mmap failed");
        return 1;
    }

    strcpy(mem, "Kernel-like protected data");
    printf("Before protection: %s\n", mem);

    // 2. "Gia cố PTE" -> Chuyển thuộc tính trang sang CHỈ ĐỌC (Mô phỏng bảo vệ vùng Code Kernel)
    if (mprotect(mem, size, PROT_READ) == -1) {
        perror("mprotect failed");
        return 1;
    }
    printf("Protection applied: READ ONLY\n");

    // 3. Thử nghiệm ghi đè -> Phần cứng / Hệ điều hành sẽ phát hiện vi phạm quyền PTE_W và gây Crash
    printf("Trying to modify...\n");
    strcpy(mem, "HACKED"); // Dòng lệnh gây lỗi sập chương trình

    // Dòng này sẽ KHÔNG bao giờ được in ra màn hình
    printf("After modify: %s\n", mem); 
    return 0;
}
