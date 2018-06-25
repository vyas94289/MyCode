func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kTableViewCellId, for: indexPath)
    
        let contain = tableView.indexPathsForSelectedRows?.contains(indexPath)
        cell.accessoryType = (contain ?? false) ? .checkmark : .none
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.submitButton.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        self.submitButton.isEnabled = !(tableView.indexPathsForSelectedRows?.isEmpty ?? true)
    }
