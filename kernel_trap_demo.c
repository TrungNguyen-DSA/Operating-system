#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>

int main() {
    // 1. Khởi tạo trang nhớ
    char *page = mmap(NULL, 4096,
                      PROT_READ | PROT_WRITE,
                      MAP_PRIVATE | MAP_ANONYMOUS,
                      -1, 0);
                      
    strcpy(page, "Secure Kernel Region");
    
    // 2. Chuyển sang chế độ bảo vệ nghiêm ngặt (Chỉ cho phép Đọc)
    mprotect(page, 4096, PROT_READ);
    printf("Trying illegal write...\n");
    
    // 3. Kích hoạt Page Fault (Mô phỏng Trap Handler nhận diện hành vi phá hoại)
    // MMU chặn lệnh phần cứng, chuyển CPU sang chế độ Trap quản lý của Kernel
    page[0] = 'Z'; 
    
    // Dòng lệnh bảo vệ này tuyệt đối không thể chạm tới
    printf("This line will not be reached\n");
    return 0;
}
