//
//  RedditDetailsViewModelSpecs.swift
//  RedditProjectTests
//
//  Created by Ivan Bober on 13/12/2020.
//

import Foundation
import Quick
import Nimble
import RxSwift

@testable import RedditProject

class RedditDetailsViewModelSpecs: QuickSpec {
    
    override func spec() {
        var redditDetailsViewModel: RedditDetailsViewModel!
        
        describe("#RedditDetails") {

            context("When shows a details") {

                it("should see the correct information") {
                    let title = "Title"
                    let author = "Author"
                    let redditEntrie = RedditEntrie.faked(title: title, author: author)
                    
                    redditDetailsViewModel = RedditDetailsViewModel(redditEntrie: redditEntrie)
                    
                    expect(redditDetailsViewModel.title) == title
                    expect(redditDetailsViewModel.author) == author

                }
            }
        }
    }
    
}
