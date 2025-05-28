package main

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"strings"
	"time"
	"path/filepath"
)

func main() {
	reader := bufio.NewReader(os.Stdin)

	fmt.Print("Enter target time (HH:MM): ")
	input, _ := reader.ReadString('\n')
	input = strings.TrimSpace(input)

	// Parse target time
	targetTime, err := time.Parse("15:04", input)
	if err != nil {
		fmt.Println("❌ Invalid time format. Use HH:MM (24-hour).")
		return
	}

	now := time.Now()
	target := time.Date(now.Year(), now.Month(), now.Day(),
		targetTime.Hour(), targetTime.Minute(), 0, 0, now.Location())

	if target.Before(now) {
		target = target.Add(24 * time.Hour)
	}

	duration := time.Until(target)
	seconds := int(duration.Seconds())

	fmt.Printf("⏳ %d seconds left. Starting timer...\n", seconds)

	// Run the timer CLI command (which shows a progress bar)
	timerCmd := exec.Command("timer", fmt.Sprintf("%ds", seconds))
	timerCmd.Stdout = os.Stdout
	timerCmd.Stderr = os.Stderr

	if err := timerCmd.Run(); err != nil {
		fmt.Println("❌ Timer failed:", err)
		return
	}


cwd, err := os.Getwd()
if err != nil {
	fmt.Println("❌ Could not get current working directory:", err)
	return
}

iconPath := filepath.Join(cwd, "assets", "pumpkin.png")

notifyCmd := exec.Command("terminal-notifier",
	"-message", "Pomodoro",
	"-title", "Work Timer is up! Take a Break 😊",
	"-appIcon", iconPath,
	"-sound", "Crystal",
)

	if err := notifyCmd.Run(); err != nil {
		fmt.Println("❌ Notification failed:", err)
	}
}
