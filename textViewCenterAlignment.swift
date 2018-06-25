var topCorrect = (self.textView.bounds.size.height - self.textView.contentSize.height * self.textView.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        self.textView.contentInset.top = topCorrect
