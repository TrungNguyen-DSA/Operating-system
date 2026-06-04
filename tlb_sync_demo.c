#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <string.h>
#include <sys/wait.h>

int main() {
    size_t size = 4096;

    // Khởi tạo vùng nhớ chia sẻ chung mô phỏng vùng nhớ hệ thống
    char *mem = mmap(NULL, size,
                     PROT_READ | PROT_WRITE,
                     MAP_SHARED | MAP_ANONYMOUS,
                     -1, 0);
                     
    strcpy(mem, "INITIAL DATA");

    pid_t pid = fork();

    if (pid == 0) {
        // --- TIẾN TRÌNH CON (Mô phỏng một Core phụ xử lý luồng) ---
        sleep(2); // Chờ 2 giây đảm bảo Tiến trình Cha đã thay đổi cấu hình PTE
        
        printf("[Child] Reading memory: %s\n", mem);
        printf("[Child] Trying write...\n");
        
        // Cố tình thực hiện lệnh ghi đè dữ liệu
        mem[0] = 'X';  
        
        // Nếu việc đồng bộ quyền thất bại, dòng này sẽ chạy. Ngược lại, Con sẽ bị sập.
        printf("[Child] Done\n");
        exit(0);
    } else {
        // --- TIẾN TRÌNH CHA (Mô phỏng Kernel Core chỉnh sửa PTE & thực hiện Flush TLB) ---
        sleep(1); // Chờ Con khởi động ổn định
        
        printf("[Parent] Applying protection (READ ONLY)\n");
        // Tiến hành khóa quyền ghi trên vùng nhớ chia sẻ này
        mprotect(mem, size, PROT_READ);
        printf("[Parent] Sync done (like TLB flush)\n");
        
        // Đợi tiến trình con xử lý xong (bị hủy do lỗi bảo mật)
        int status;
        wait(&status);
        
        if (WIFSIGNALED(status)) {
            printf("[Parent] Kiem chung: Tien trinh con da bi sập do vi pham phan quyen dong bo!\n");
        }
    } 
    return 0;
}
